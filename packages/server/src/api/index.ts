import express from "express";
import { PrismaClientSingleton, Resume, generateDummyResume, generateImage, generatePDF } from "../utils";
const router = express.Router();

router.get("/", (req, res) => res.send("Hello World!"));

/** Generate new resume */
router.post("/generate", async (req, res) => {
  if (!("resume" in req.body && "isDummy" in req.body)) {
    res.status(400).send("resume and isDummy field is missing");
    return;
  }

  let { resume, isDummy }: { resume: Resume; isDummy: string } = req.body;

  if (isDummy === "yes") {
    const dummyResume = generateDummyResume();
    resume = dummyResume;
  }

  if (!resume) {
    res.status(400).send("resume field is missing");
    return;
  }

  const [imageUrl, pdfUrl] = await Promise.all([generateImage(resume), generatePDF(resume)]);

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
            create: req.body.personalDetails,
            update: req.body.personalDetails,
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        skills: {
          upsert: {
            where: { id: req.body.skill.id },
            create: req.body.skill,
            update: req.body.skill,
          },
        },
      },
    });

    res.json(req.body.skill);
    return;
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
            id: req.body.id,
          },
        },
      },
    });

    res.json({ id: req.body.id });
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
            create: req.body.hobby,
            update: req.body.hobby,
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

  res.json({ id: req.body });
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

  if ("professionalSummary" in req.body) {
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        professionalSummary: {
          upsert: {
            create: req.body.professionalSummary,
            update: req.body.professionalSummary,
          },
        },
      },
    });

    res.json(req.body.professionalSummary);
    return;
  } else {
    res.status(400).json({ message: "professionalSummary field is missing" });
    return;
  }
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

  res.json({});
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        languages: {
          upsert: {
            where: { id: req.body.language.id },
            create: req.body.language,
            update: req.body.language,
          },
        },
      },
    });

    res.json(req.body.language);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        courses: {
          upsert: {
            where: { id: req.body.course.id },
            create: req.body.course,
            update: req.body.course,
          },
        },
      },
    });

    res.json(req.body.course);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        educations: {
          upsert: {
            where: { id: req.body.education.id },
            create: req.body.education,
            update: req.body.education,
          },
        },
      },
    });

    res.json(req.body.education);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        employmentHistories: {
          upsert: {
            where: { id: req.body.employmentHistory.id },
            create: req.body.employmentHistory,
            update: req.body.employmentHistory,
          },
        },
      },
    });

    res.json(req.body.employmentHistory);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        internships: {
          upsert: {
            where: { id: req.body.internship.id },
            create: req.body.internship,
            update: req.body.internship,
          },
        },
      },
    });

    res.json(req.body.internship);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
    await prisma.user.update({
      where: {
        email: email,
      },
      data: {
        links: {
          upsert: {
            where: { id: req.body.link.id },
            create: req.body.link,
            update: req.body.link,
          },
        },
      },
    });

    res.json(req.body.link);
    return;
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
          delete: { id: req.body.id },
        },
      },
    });

    res.json({ id: req.body.id });
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
            create: req.body.subscription,
            update: req.body.subscription,
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

    res.json({ id: req.body.id });
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

export default router;
