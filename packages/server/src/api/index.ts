import express from "express";
import { PrismaClientSingleton, doUserAlreadyExit, generateDummyResume, generateImage, generatePDF } from "../utils";
const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

/** Generate new resume */
router.post("/generate", async (req, res) => {
  // resume is required
  // isDummy is required
  // check for this properites
  if (!("resume" in req.body && "isDummy" in req.body)) {
    res.status(400).send("resume and isDummy field is missing");
    return;
  }

  let { resume, isDummy } = req.body;

  if (isDummy === "yes") {
    const dummyResume = generateDummyResume();
    resume = dummyResume;
  }

  if (!resume) {
    res.status(400).send("resume field is missing");
    return;
  }

  const [imageUrl, pdfUrl] = await Promise.all([generateImage(resume), generatePDF(resume)]);
  const resumeForDB = `${JSON.stringify({ imageUrl: `${imageUrl}`, pdfUrl: `${pdfUrl}` })}==========${JSON.stringify(resume)}`;

  // add this generated resume to the user
  const addToUsers = async () => {
    const email = res.locals.email;
    const prisma = PrismaClientSingleton.prisma;

    const updatedUser = await prisma.user.update({
      where: { email: email },
      data: {
        resumes: {
          create: {
            data: resumeForDB,
            updatedAt: new Date(),
          },
        },
      },
      select: {
        resumes: {
          select: {
            id: true,
          },
        },
      },
    });

    const insertedResumeId = updatedUser.resumes[updatedUser.resumes.length - 1].id;
    return insertedResumeId;
  };

  const insertedId = await addToUsers();

  res.send({ imageUrl: `${imageUrl}`, pdfUrl: `${pdfUrl}`, id: insertedId });
});

/** Get all the generated resume of the user */
router.post("/generated_resumes", async (req, res) => {
  const email = res.locals.email;

  const targetUser = await doUserAlreadyExit(email);
  if (!targetUser) {
    res.status(500).json({ message: "User not found" });
    return;
  }

  const userId = targetUser.id;
  const prisma = PrismaClientSingleton.prisma;

  const generatedResumes = await prisma.resumes.findMany({
    where: {
      userId: userId,
    },
  });

  const finalResumes = generatedResumes
    .map((p) => {
      return { ...p, data: null, resumeRow: JSON.parse((p.data as string).split("==========")[1]), resume: JSON.parse((p.data as string).split("==========")[0]) };
    })
    .map((p: any) => {
      delete p.data;
      return p;
    });

  res.json({ generatedResumes: finalResumes });
});

/** Get the single generated resume of the user */
router.post("/generated_resume", async (req, res) => {
  const email = res.locals.email;
  const resumeId = req.body.resumeId;
  const prisma = PrismaClientSingleton.prisma;

  const generatedResumes = await prisma.resumes.findUnique({
    where: {
      id: resumeId,
    },
  });

  if (!generatedResumes) {
    res.status(500).json({ message: "Resume not found" });
    return;
  }

  const finalResumes = {
    ...generatedResumes,
    data: null,
    resumeRow: JSON.parse((generatedResumes.data as string).split("==========")[1]),
    resume: JSON.parse((generatedResumes.data as string).split("==========")[0]),
  };

  res.json({ generatedResume: finalResumes });
});

export default router;
