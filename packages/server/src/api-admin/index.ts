import express from "express";
import { PrismaClientSingleton, Resume, generateDummyResume, generateImage } from "../utils";

const router = express.Router();

/**
 *
 * Add new template to the market place
 */
router.post("/add_template", async (req, res) => {
  if (!("name" in req.body)) {
    res.status(400).json({ message: "name field is missing" });
    return;
  }

  if (!("price" in req.body)) {
    res.status(400).json({ message: "price field is missing" });
    return;
  }

  const email = res.locals.email;
  const name = req.body.name;
  const price = +req.body.price; // in paisa

  const loadTemplate = async () => {
    const template = await import(`../templates/${name}`);
    return template as unknown as { default: (resume: Resume) => string };
  };

  const template = await loadTemplate();
  console.log(template);

  // generate the dummy template for the preview
  const dummyResume = generateDummyResume();
  const imageUrl = await generateImage(dummyResume, template.default)

  // add to the database template marketplace
  const prisma = PrismaClientSingleton.prisma;
  await prisma.resumeTemplateMarketplace.create({
    data: {
      name: name,
      price: price,
      previewImgUrl: imageUrl,
    },
  });

  res.json({ imageUrl: imageUrl, price: price });
});

export default router;
