import express from "express";
import { PrismaClientSingleton, Resume, addTemplate, generateDummyResume, generateImage } from "../utils";

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

  const imageUrl = await addTemplate(name, price);

  res.json({ imageUrl: imageUrl, price: price });
});

export default router;
