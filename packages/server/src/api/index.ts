import express from "express";
import { rmSync } from "fs";
import path from "path";
import { Order, PrismaClientSingleton, Resume, Subscription, generateDummyResume, generateImage, generatePDF, sanitizePrismaData } from "../utils";
import { buyTemplate } from "../views/buy-template";
const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

/** Update the resume */
router.post("/update_resume", async (req, res) => {
  if (!("resume" in req.body && "id" in req.body)) {
    res.status(400).send("resume field and id field is missing");
    return;
  }

  const email = res.locals.email;
  let resume = req.body.resume as Resume;
  const resumeID = req.body.id;

  // fetched old resume
  const prisma = PrismaClientSingleton.prisma;
  const oldResume = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      profilePicture: true,
      resumes: {
        where: {
          id: resumeID,
        },
      },
    },
  });

  if (!oldResume) {
    res.status(500).send("resume not found");
    return;
  }

  // we need to maintain the UUID of the file name
  const imageUrlOld = oldResume.resumes[0].imageUrl;
  const pdfUrlOld = oldResume.resumes[0].pdfUrl;

  const uuidImageUrl = imageUrlOld.split(".")[0];
  const uuidPdfUrl = pdfUrlOld.split(".")[0];

  // delete this file located in the public folder
  const publicFolderPath = path.join(process.cwd(), "public");
  const oldImageFilePath = path.join(publicFolderPath, `${uuidImageUrl}.png`);
  const oldPdfFilePath = path.join(publicFolderPath, `${uuidPdfUrl}.pdf`);
  rmSync(oldImageFilePath);
  rmSync(oldPdfFilePath);

  const templateName = oldResume.resumes[0].templateName;
  const loadTemplate = async () => {
    const template = await import(`../templates/${templateName}`);
    return template as unknown as { default: (resume: Resume) => string };
  };

  const template = await loadTemplate();

  const [imageUrl, pdfUrl] = await Promise.all([generateImage(resume, template.default), generatePDF(resume, template.default)]);

  if (!imageUrl || !pdfUrl) {
    res.status(500).send("Something went wrong");
    return;
  }

  // add this generated resume to the user
  await prisma.user.update({
    where: { email: email },
    data: {
      resumes: {
        update: {
          where: {
            id: resumeID,
          },
          data: {
            imageUrl: imageUrl,
            pdfUrl: pdfUrl,
            resume: JSON.parse(JSON.stringify(resume)),
          },
        },
      },
    },
  });

  res.send({
    imageUrl: imageUrl,
    pdfUrl: pdfUrl,
    userId: oldResume.resumes[0].userId,
    createdAt: oldResume.resumes[0].createdAt,
    updatedAt: oldResume.resumes[0].updatedAt,
    id: resumeID,
    resume: resume,
    templateName: oldResume.resumes[0].templateName,
  });
});

/** Generate new resume */
router.post("/generate", async (req, res) => {
  if (!("resume" in req.body && "isDummy" in req.body && "templateName" in req.body)) {
    res.status(400).send("resume and isDummy field is missing");
    return;
  }

  let { resume, isDummy, templateName }: { resume: Resume; isDummy: string; templateName: string } = req.body;

  if (isDummy === "yes") {
    const dummyResume = generateDummyResume();
    resume = dummyResume;
  }

  if (!resume) {
    res.status(400).send("resume field is missing");
    return;
  }

  if (!templateName) {
    res.status(400).send("templateName field is missing");
    return;
  }

  const loadTemplate = async () => {
    const template = await import(`../templates/${templateName}`);
    return template as unknown as { default: (resume: Resume) => string };
  };

  const template = await loadTemplate();

  const [imageUrl, pdfUrl] = await Promise.all([generateImage(resume, template.default), generatePDF(resume, template.default)]);

  if (!imageUrl || !pdfUrl) {
    res.status(500).send("Something went wrong");
    return;
  }

  // add this generated resume to the user
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const insertedResume = await prisma.user.update({
    where: { email: email },
    data: {
      resumes: {
        create: {
          imageUrl: imageUrl,
          pdfUrl: pdfUrl,
          resume: JSON.parse(JSON.stringify(resume)),
          templateName: templateName,
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

  const insertedId = insertedResume.resumes[insertedResume.resumes.length - 1].id;
  res.send({ imageUrl: imageUrl, pdfUrl: pdfUrl, id: insertedId });
});

/**
 *
 * Get the generated resumes of the user
 *
 */
router.post("/generated_resumes", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const resumes = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      resumes: true,
    },
  });

  if (!resumes) {
    res.status(500).json({ message: "resumes not found" });
    return;
  }

  res.json(resumes.resumes);
  return;
});

/**
 *
 * Get the generated resume
 *
 */
router.post("/generated_resume", async (req, res) => {
  if (!("resumeId" in req.body)) {
    res.status(400).send("resumeId field is missing");
    return;
  }

  const email = res.locals.email;
  const resumeId = req.body.resumeId;
  const prisma = PrismaClientSingleton.prisma;

  const resume = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      resumes: {
        where: {
          id: resumeId,
        },
        orderBy: {
          createdAt: "desc",
        },
      },
    },
  });

  if (!resume) {
    res.status(500).json({ message: "resume not found" });
    return;
  }

  res.json(resume.resumes[0]);
  return;
});

/**
 *
 *
 * Delete the resume
 */
router.post("/delete_resume", async (req, res) => {
  if (!("id" in req.body)) {
    res.status(400).send("id field is missing");
    return;
  }

  const email = res.locals.email;
  const resumeID = req.body.id;

  // fetch old resume
  const prisma = PrismaClientSingleton.prisma;
  const oldResume = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      resumes: {
        where: {
          id: resumeID,
        },
      },
    },
  });

  if (!oldResume) {
    res.status(500).send("resume not found");
    return;
  }

  // delete this file located in the public folder
  const publicFolderPath = path.join(process.cwd(), "public");
  const oldImageFilePath = path.join(publicFolderPath, `${oldResume.resumes[0].imageUrl}`);
  const oldPdfFilePath = path.join(publicFolderPath, `${oldResume.resumes[0].pdfUrl}`);
  rmSync(oldImageFilePath);
  rmSync(oldPdfFilePath);

  // delete the resume from database
  await prisma.user.update({
    where: { email: email },
    data: {
      resumes: {
        delete: {
          id: resumeID,
        },
      },
    },
  });

  res.send({
    id: resumeID,
  });
});

/**
 *
 * Get user details
 *
 */
router.post("/user_details", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const userDetails = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      personalDetails: true,
    },
  });

  if (!userDetails) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!userDetails.personalDetails) {
    res.status(500).json({ message: "personalDetails not found" });
    return;
  }

  res.json(userDetails.personalDetails);
  return;
});

/**
 *
 * Update add the user details
 *
 */
router.post("/add_update_user_details", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("personalDetails" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        personalDetails: {
          upsert: {
            create: sanitizePrismaData(req.body.personalDetails),
            update: sanitizePrismaData(req.body.personalDetails),
          },
        },
      },
    });

    res.json(req.body.personalDetails);
    return;
  } else {
    // no personal details
    res.status(400).json({ message: "personalDetails field is missing" });
    return;
  }
});

/**
 *
 * Get user skills
 *
 */
router.post("/user_skills", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const userSkills = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      skills: true,
    },
  });

  if (!userSkills) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!userSkills.skills) {
    res.status(500).json({ message: "skills not found" });
    return;
  }

  res.json(userSkills.skills);
  return;
});
/**
 * Add update user skill
 */
router.post("/add_update_user_skill", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("skill" in req.body) {
    const oldSkills = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        skills: true,
      },
    });

    const newSkills = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        skills: {
          upsert: {
            where: { id: +req.body.skill.id },
            create: sanitizePrismaData(req.body.skill),
            update: sanitizePrismaData(req.body.skill),
          },
        },
      },
      select: {
        skills: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldSkills?.skills.length !== newSkills.skills.length) {
      // we have created new skills
      const createdSkill = newSkills.skills[0];
      res.json(createdSkill);
      return;
    } else {
      // we have updated existing skills
      res.json(req.body.skill);
      return;
    }
  } else {
    res.status(400).json({ message: "skill field is missing" });
    return;
  }
});

/**
 * Delete user skill
 */
router.post("/delete_user_skill", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        skills: {
          delete: {
            id: +req.body.id,
          },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get hobby of the user
 *
 */
router.post("/get_user_hobby", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const hobby = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      hobby: true,
    },
  });

  if (!hobby) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!hobby.hobby) {
    res.status(500).json({ message: "hobby not found" });
    return;
  }

  res.json(hobby.hobby);
  return;
});

/**
 *
 * Add update the hobby of the user
 *
 */
router.post("/add_update_user_hobby", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("hobby" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        hobby: {
          upsert: {
            create: sanitizePrismaData(req.body.hobby),
            update: sanitizePrismaData(req.body.hobby),
          },
        },
      },
    });

    res.json(req.body.hobby);
    return;
  } else {
    res.status(400).json({ message: "hobby field is missing" });
    return;
  }
});
/**
 *
 * Delete the hobby of the user
 *
 */
router.post("/delete_user_hobby", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  await prisma.user.update({
    where: {
      email: email,
    },
    data: {
      hobby: {
        delete: true,
      },
    },
  });

  res.json({ id: 0 });
  return;
});

/**
 *
 * Get professionalSummary of the user
 *
 */
router.post("/get_user_professional_summary", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const professionalSummary = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      professionalSummary: true,
    },
  });

  if (!professionalSummary) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!professionalSummary.professionalSummary) {
    res.status(500).json({ message: "professionalSummary field is missing" });
    return;
  }

  res.json(professionalSummary.professionalSummary);
  return;
});

/**
 *
 * Add update the professionalSummary of the user
 *
 */
router.post("/add_update_user_professional_summary", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;
  if (!("professionalSummary" in req.body)) {
    res.status(400).json({ message: "professionalSummary field is missing" });
    return;
  }

  await prisma.user.update({
    where: {
      email: email,
    },
    data: {
      professionalSummary: {
        upsert: {
          create: sanitizePrismaData(req.body.professionalSummary),
          update: sanitizePrismaData(req.body.professionalSummary),
        },
      },
    },
  });

  res.json(req.body.professionalSummary);
  return;
});

/**
 *
 * Delete the professionalSummary of the user
 *
 */
router.post("/delete_user_professional_summary", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  await prisma.user.update({
    where: {
      email: email,
    },
    data: {
      professionalSummary: {
        delete: true,
      },
    },
  });

  res.json({ id: 0 });
  return;
});
/**
 *
 * Get languages of the user
 *
 */
router.post("/get_user_languages", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const languages = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      languages: true,
    },
  });

  if (!languages) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!languages.languages) {
    res.status(500).json({ message: "languages field is missing" });
    return;
  }

  res.json(languages.languages);
  return;
});

/**
 *
 * Add update the language of the user
 *
 */
router.post("/add_update_user_language", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("language" in req.body) {
    const oldLanguages = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        languages: true,
      },
    });

    const newLanguages = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        languages: {
          upsert: {
            where: { id: +req.body.language.id },
            create: sanitizePrismaData(req.body.language),
            update: sanitizePrismaData(req.body.language),
          },
        },
      },
      select: {
        languages: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldLanguages?.languages.length !== newLanguages.languages.length) {
      // we have created new languages
      const createdLanguage = newLanguages.languages[0];
      res.json(createdLanguage);
      return;
    } else {
      // we have updated existing languages
      res.json(req.body.language);
      return;
    }
  } else {
    res.status(400).json({ message: "language field is missing" });
    return;
  }
});

/**
 *
 * Delete the language of the user
 *
 */
router.post("/delete_user_language", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        languages: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get all courses of the user
 *
 */
router.post("/get_user_courses", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const courses = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      courses: true,
    },
  });

  if (!courses) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!courses.courses) {
    res.status(500).json({ message: "courses field is missing" });
    return;
  }

  res.json(courses.courses);
  return;
});

/**
 *
 * Add update the course of the user
 *
 */
router.post("/add_update_user_course", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("course" in req.body) {
    const oldCourses = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        courses: true,
      },
    });

    const newCourses = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        courses: {
          upsert: {
            where: { id: +req.body.course.id },
            create: sanitizePrismaData(req.body.course),
            update: sanitizePrismaData(req.body.course),
          },
        },
      },
      select: {
        courses: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldCourses?.courses.length !== newCourses.courses.length) {
      // we have created new courses
      const createdCourse = newCourses.courses[0];
      res.json(createdCourse);
      return;
    } else {
      // we have updated existing courses
      res.json(req.body.course);
      return;
    }
  } else {
    res.status(400).json({ message: "course field is missing" });
    return;
  }
});

/**
 *
 * Delete the course of the user
 *
 */
router.post("/delete_user_course", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        courses: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get all educations of the user
 *
 */
router.post("/get_user_educations", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const educations = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      educations: true,
    },
  });

  if (!educations) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!educations.educations) {
    res.status(500).json({ message: "educations field is missing" });
    return;
  }

  res.json(educations.educations);
  return;
});
/**
 *
 * Add update the education of the user
 *
 */
router.post("/add_update_user_education", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("education" in req.body) {
    const oldEducations = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        educations: true,
      },
    });

    const newEducations = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        educations: {
          upsert: {
            where: { id: +req.body.education.id },
            create: sanitizePrismaData(req.body.education),
            update: sanitizePrismaData(req.body.education),
          },
        },
      },
      select: {
        educations: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldEducations?.educations.length !== newEducations.educations.length) {
      // we have created new educations
      const createdEducation = newEducations.educations[0];
      res.json(createdEducation);
      return;
    } else {
      // we have updated existing educations
      res.json(req.body.education);
      return;
    }
  } else {
    res.status(400).json({ message: "education field is missing" });
    return;
  }
});
/**
 *
 * Delete the education of the user
 *
 */
router.post("/delete_user_education", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        educations: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get all employmentHistories of the user
 *
 */
router.post("/get_user_employment_histories", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const employmentHistories = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      employmentHistories: true,
    },
  });

  if (!employmentHistories) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!employmentHistories.employmentHistories) {
    res.status(500).json({ message: "employmentHistories field is missing" });
    return;
  }

  res.json(employmentHistories.employmentHistories);
  return;
});
/**
 *
 * Add update the employmentHistory of the user
 *
 */
router.post("/add_update_user_employment_history", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("employmentHistory" in req.body) {
    const oldEmploymentHistories = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        employmentHistories: true,
      },
    });

    const newEmploymentHistories = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        employmentHistories: {
          upsert: {
            where: { id: +req.body.employmentHistory.id },
            create: sanitizePrismaData(req.body.employmentHistory),
            update: sanitizePrismaData(req.body.employmentHistory),
          },
        },
      },
      select: {
        employmentHistories: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldEmploymentHistories?.employmentHistories.length !== newEmploymentHistories.employmentHistories.length) {
      // we have created new employmentHistories
      const createdEmploymentHistory = newEmploymentHistories.employmentHistories[0];
      res.json(createdEmploymentHistory);
      return;
    } else {
      // we have updated existing employmentHistories
      res.json(req.body.employmentHistory);
      return;
    }
  } else {
    res.status(400).json({ message: "employmentHistory field is missing" });
    return;
  }
});
/**
 *
 * Delete the employmentHistory of the user
 *
 */
router.post("/delete_user_employment_history", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        employmentHistories: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get all internships of the user
 *
 */
router.post("/get_user_internships", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const internships = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      internships: true,
    },
  });

  if (!internships) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!internships.internships) {
    res.status(500).json({ message: "internships field is missing" });
    return;
  }

  res.json(internships.internships);
  return;
});

/**
 *
 * Add update the internship of the user
 *
 */
router.post("/add_update_user_internship", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("internship" in req.body) {
    const oldInternships = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        internships: true,
      },
    });

    const newInternships = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        internships: {
          upsert: {
            where: { id: +req.body.internship.id },
            create: sanitizePrismaData(req.body.internship),
            update: sanitizePrismaData(req.body.internship),
          },
        },
      },
      select: {
        internships: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldInternships?.internships.length !== newInternships.internships.length) {
      // we have created new internships
      const createdInternship = newInternships.internships[0];
      res.json(createdInternship);
      return;
    } else {
      // we have updated existing internships
      res.json(req.body.internship);
      return;
    }
  } else {
    res.status(400).json({ message: "internship field is missing" });
    return;
  }
});

/**
 *
 * Delete the internship of the user
 *
 */
router.post("/delete_user_internship", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        internships: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get all links of the user
 *
 */
router.post("/get_user_links", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const links = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      links: true,
    },
  });

  if (!links) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!links.links) {
    res.status(500).json({ message: "links field is missing" });
    return;
  }

  res.json(links.links);
  return;
});

/**
 *
 * Add update the link of the user
 *
 */
router.post("/add_update_user_link", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("link" in req.body) {
    const oldLinks = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        links: true,
      },
    });

    const newLinks = await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        links: {
          upsert: {
            where: { id: +req.body.link.id },
            create: sanitizePrismaData(req.body.link),
            update: sanitizePrismaData(req.body.link),
          },
        },
      },
      select: {
        links: {
          orderBy: {
            id: "desc",
          },
        },
      },
    });

    if (oldLinks?.links.length !== newLinks.links.length) {
      // we have created new links
      const createdLink = newLinks.links[0];
      res.json(createdLink);
      return;
    } else {
      // we have updated existing links
      res.json(req.body.link);
      return;
    }
  } else {
    res.status(400).json({ message: "link field is missing" });
    return;
  }
});

/**
 *
 * Delete the link of the user
 *
 */
router.post("/delete_user_link", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        links: {
          delete: { id: +req.body.id },
        },
      },
    });

    res.json({ id: +req.body.id });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});
/**
 *
 * Get subscription of the user
 *
 */
router.post("/get_user_subscription", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const subscription = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      subscription: true,
    },
  });

  if (!subscription) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!subscription.subscription) {
    res.status(500).json({ message: "subscription field is missing" });
    return;
  }

  res.json(subscription.subscription);
  return;
});

/**
 *
 * Add update the subscription of the user
 *
 */
router.post("/add_update_user_subscription", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("subscription" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        subscription: {
          upsert: {
            create: sanitizePrismaData(req.body.subscription),
            update: sanitizePrismaData(req.body.subscription),
          },
        },
      },
    });

    res.json(req.body.subscription);
    return;
  } else {
    res.status(400).json({ message: "subscription field is missing" });
    return;
  }
});

/**
 *
 * Delete the subscription of the user
 *
 */
router.post("/delete_user_subscription", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  if ("id" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        subscription: {
          delete: true,
        },
      },
    });

    res.json({ id: 0 });
    return;
  } else {
    res.status(400).json({ message: "id field is missing" });
    return;
  }
});

/**
 *
 * Get user
 *
 */
router.post("/get_user", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      courses: false,
      educations: false,
      employmentHistories: false,
      internships: false,
      links: false,
      subscription: true,
      createdAt: true,
      email: true,
      fullName: true,
      hobby: false,
      id: true,
      languages: false,
      password: false,
      personalDetails: false,
      professionalSummary: false,
      profilePicture: true,
      reference: true,
      resumes: false,
      skills: false,
      updatedAt: true,
    },
  });

  if (!user) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  res.json(user);
  return;
});

/**
 *
 *
 * Generate the order for the template
 */
router.post("/generate_order", async (req, res) => {
  if (!("nameOfTemplate" in req.body)) {
    res.status(400).json({ message: "nameOfTemplate field is missing" });
    return;
  }

  const email = res.locals.email;
  const Razorpay = require("razorpay");
  const razorpayKeyID = process.env.RAZORPAY_KEY_ID;
  const razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET;
  const nameOfTemplate = req.body.nameOfTemplate;
  const instance = new Razorpay({ key_id: razorpayKeyID, key_secret: razorpayKeySecret });
  const prisma = PrismaClientSingleton.prisma;

  const marketPlaceTemplate = await prisma.resumeTemplateMarketplace.findUnique({
    where: {
      name: nameOfTemplate,
    },
  });

  // get the current user
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
  });

  if (!user) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!marketPlaceTemplate) {
    res.status(500).json({ message: "template not found" });
    return;
  }

  if (+marketPlaceTemplate.price === 0) {
    res.status(500).json({ message: "template price is 0" });
    return;
  }

  // generate the order
  const order = await instance.orders.create({
    amount: +marketPlaceTemplate.price,
    currency: "INR",
    payment_capture: 1,
    notes: {
      email: user.email,
      templateName: nameOfTemplate,
    },
  });

  res.json(order);
});

/**
 *
 *
 * Create subscription
 */
router.post("/create_subscription", async (req, res) => {
  if (!("planName" in req.body && req.body.planName)) {
    res.status(400).json({ message: "planName field is missing" });
    return;
  }

  const email = res.locals.email;
  const planName = req.body.planName;
  const prisma = PrismaClientSingleton.prisma;
  const razorpayKeyID = process.env.RAZORPAY_KEY_ID;
  const razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET;
  const Razorpay = require("razorpay");
  const instance = new Razorpay({ key_id: razorpayKeyID, key_secret: razorpayKeySecret });

  // if already created then just return the link
  const oldSubscription = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      subscription: true,
    },
  });

  if (oldSubscription && oldSubscription.subscription) {
    res.json(oldSubscription.subscription.subscriptionLink);
    return;
  }

  const targetPlan = await prisma.admin.findUnique({
    where: {
      email: process.env.ADMIN_EMAIL || "",
    },
    select: {
      premiumTemplatePlans: {
        where: {
          name: planName,
        },
      },
    },
  });

  if (!(targetPlan && targetPlan.premiumTemplatePlans.length !== 0)) {
    res.status(500).json({ message: "plan not found" });
    return;
  }

  const choosenPlan = targetPlan.premiumTemplatePlans[0];

  const subscriptionCreated: Subscription = await instance.subscriptions.create({
    plan_id: choosenPlan.planID,
    customer_notify: 1,
    quantity: 1,
    total_count: 12,
    addons: [],
    notes: {
      email: email,
    },
  });

  // add to the database
  await prisma.user.update({
    where: {
      email: email,
    },
    data: {
      subscription: {
        create: {
          activatedOn: new Date(),
          basePrice: +choosenPlan.price, // in paisa
          cycle: "MONTHLY",
          discount: 0,
          expireOn: new Date(),
          isActive: false,
          planName: planName,
          subscriptionID: subscriptionCreated.id,
          subscriptionLink: subscriptionCreated.short_url,
        },
      },
    },
  });

  res.json(subscriptionCreated.short_url);
});

/**
 *
 *
 * Get templates for marketplace
 */
router.post("/get_marketplace_templates", async (req, res) => {
  const prisma = PrismaClientSingleton.prisma;
  const email = res.locals.email;

  const boughtTemplate = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      boughtTemplate: true,
    },
  });

  const allTemplates = await prisma.resumeTemplateMarketplace.findMany({});

  const allTemplateFinal = allTemplates.map((p) => {
    return { ...p, isFree: p.price === 0, isBought: !!boughtTemplate?.boughtTemplate.find((val) => val.name === p.name) };
  });

  res.json(allTemplateFinal);
});

/**
 *
 *
 * Is template bought
 */
router.post("/is_template_bought", async (req, res) => {
  if (!("templateName" in req.body)) {
    res.status(400).json({ message: "templateName field is missing" });
    return;
  }

  const email = res.locals.email;
  const templateName = req.body.templateName;
  const prisma = PrismaClientSingleton.prisma;

  const template = await prisma.resumeTemplateMarketplace.findUnique({
    where: {
      name: templateName,
    },
  });

  if (!template) {
    res.status(500).json({ message: "template not found" });
    return;
  }

  const price = template.price;
  const isFree = price === 0;
  if (isFree) {
    res.json({ isBought: true });
    return;
  } else {
    // check if bought
    const boughtTemplate = await prisma.user.findUnique({
      where: {
        email: email,
      },
      select: {
        boughtTemplate: {
          where: {
            name: templateName,
          },
        },
      },
    });

    if (!boughtTemplate) {
      res.json({ isBought: false });
      return;
    }

    if (boughtTemplate.boughtTemplate.length === 0) {
      res.json({ isBought: false });
      return;
    }

    if (boughtTemplate.boughtTemplate.length !== 0) {
      res.json({ isBought: true });
      return;
    }
  }
});

/**
 * Cancel the subscription
 */
router.post("/cancel_subscription", async (req, res) => {
  const email = res.locals.email;
  const prisma = PrismaClientSingleton.prisma;

  const subscriptionOld = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      subscription: true,
    },
  });

  if (!subscriptionOld || !subscriptionOld.subscription) {
    res.status(500).json({ message: "subscription not found" });
    return;
  }

  const subsID = subscriptionOld.subscription.subscriptionID;

  // delete from the razorpay
  const Razorpay = require("razorpay");
  const instance = new Razorpay({ key_id: process.env.RAZORPAY_KEY_ID, key_secret: process.env.RAZORPAY_KEY_SECRET });
  await instance.subscriptions.cancel(subsID, { cancel_at_cycle_end: 1 });

  res.json({ message: "subscription cancelled" });
});


// For the buy template get req with auth token and template name
router.get("/template/:name", async (req, res) => {
  const templateName = req.params.name;
  const hostName = req.query.hostName as string;
  const email = res.locals.email;

  const Razorpay = require("razorpay");
  const razorpayKeyID = process.env.RAZORPAY_KEY_ID;
  const razorpayKeySecret = process.env.RAZORPAY_KEY_SECRET;
  const nameOfTemplate = templateName;
  const instance = new Razorpay({ key_id: razorpayKeyID, key_secret: razorpayKeySecret });
  const prisma = PrismaClientSingleton.prisma;

  const marketPlaceTemplate = await prisma.resumeTemplateMarketplace.findUnique({
    where: {
      name: nameOfTemplate,
    },
  });

  // get the current user
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
  });

  if (!user) {
    res.status(500).json({ message: "user not found" });
    return;
  }

  if (!marketPlaceTemplate) {
    res.status(500).json({ message: "template not found" });
    return;
  }

  if (+marketPlaceTemplate.price === 0) {
    res.status(500).json({ message: "template price is 0" });
    return;
  }

  // is already bought
  const boughtTemplate = await prisma.user.findUnique({
    where: {
      email: email,
    },
    select: {
      boughtTemplate: {
        where: {
          name: nameOfTemplate,
        },
      },
    },
  });

  if (boughtTemplate && boughtTemplate.boughtTemplate.length !== 0) {
    res.status(500).json({ message: "template already bought" });
    return;
  }
  
  // generate the order
  const order: Order = await instance.orders.create({
    amount: +marketPlaceTemplate.price,
    currency: "INR",
    payment_capture: 1,
    notes: {
      email: user.email,
      templateName: nameOfTemplate,
    },
  });

  // return the web page
  res.set("Content-Type", "text/html"); 
  res.send(buyTemplate(marketPlaceTemplate.previewImgUrl, order.amount, order.id, user.fullName, "", user.email, hostName));
});

/** Get single the premium plan */
router.post("/get_premium_plan", async (req, res) => {
   const email = res.locals.email;
   const prisma = PrismaClientSingleton.prisma;

   const targetPlan = await prisma.admin.findUnique({
     where: {
       email: process.env.ADMIN_EMAIL || "",
     },
     select: {
       premiumTemplatePlans: true,
     },
   });

   if (!(targetPlan && targetPlan.premiumTemplatePlans.length !== 0)) {
     res.status(500).json({ message: "plan not found" });
     return;
   }

   res.json(targetPlan.premiumTemplatePlans[0]);
});

export default router;
