const { getClient } = require("../config/database");
const { ObjectId } = require("mongodb");

async function savepicture(req, res) {
  if (!req.file) {
    return res.status(400).send("No image file provided.");
  }
  try {
    const client = getClient();
    const db = client.db();
    const petCollection = db.collection("imagepets");
    const imageBase64 = Buffer.from(req.file.buffer).toString("base64");
    const result = await petCollection.insertOne({ content: imageBase64 });
    const imageId = result.insertedId;
    res
      .status(201)
      .send({ message: "Image uploaded successfully", id: imageId });
  } catch (error) {
    res
      .status(500)
      .send({ message: "Failed to upload image", error: error.toString() });
  }
}

async function fetchImages(req, res) {
  try {
    const client = getClient();
    await client.connect();
    const db = client.db();
    const petCollection = db.collection("imagepets");

    const images = await petCollection.find({}).toArray();
    if (images.length === 0) {
      res.status(404).send({ message: "No images found" });
      return;
    }

    const imageList = images.map((img) => ({
      id: img._id,
      content: img.content,
    }));
    res.status(200).send(imageList);
  } catch (error) {
    res
      .status(500)
      .send({ message: "Failed to fetch images", error: error.toString() });
  } finally {
    await client.close();
  }
}

async function deleteImage(req, res) {
  const imageId = req.params.id;
  if (!imageId) {
    return res.status(400).send({ message: "Image ID is required" });
  }

  try {
    const client = getClient();
    await client.connect();
    const db = client.db();
    const petCollection = db.collection("imagepets");

    const deleteResult = await petCollection.deleteOne({
      _id: ObjectId.createFromHexString(imageId),
    });
    if (deleteResult.deletedCount === 1) {
      res.status(200).send({ message: "Image deleted successfully" });
    } else {
      res.status(404).send({ message: "Image not found" });
    }
  } catch (error) {
    res
      .status(500)
      .send({ message: "Failed to delete image", error: error.toString() });
  }
}

module.exports = { savepicture, fetchImages, deleteImage };
