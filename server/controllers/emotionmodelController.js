const { ObjectId } = require("mongodb");
const { getClient } = require("../config/database");

const queryHuggingFace = async (imageBuffer, retries = 3) => {
  try {
    const response = await fetch(
      "https://api-inference.huggingface.co/models/Dewa/dog_emotion_v2",
      {
        headers: {
          Authorization: "Bearer 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",
        },
        method: "POST",
        body: imageBuffer,
      }
    );

    if (!response.ok) {
      if (response.status === 503 && retries > 0) {
        console.warn(`Hugging Face API responded with status 503. Retrying... (${retries} retries left)`);
        await new Promise(res => setTimeout(res, 1000)); // Wait for 1 second before retrying
        return queryHuggingFace(imageBuffer, retries - 1);
      } else {
        throw new Error(`Hugging Face API responded with status ${response.status}`);
      }
    }

    const result = await response.json();

    if (result && result.length > 0) {
      const bestEmotion = result.reduce((max, obj) =>
        obj.score > max.score ? obj : max
      );
      return bestEmotion;
    } else {
      return null;
    }
  } catch (error) {
    console.error("Error querying Hugging Face API:", error);
    throw error;
  }
};

const analyzeImage = async (imageId) => {
  const client = getClient();
  await client.connect();
  const db = client.db();
  const petCollection = db.collection("imagepets");

  const imageDoc = await petCollection.findOne({
    _id: ObjectId.createFromHexString(imageId),
  });

  if (!imageDoc) {
    throw new Error("Image not found");
  }

  const imageBuffer = Buffer.from(imageDoc.content, "base64");

  console.log(`Image buffer size: ${imageBuffer.length} bytes`);

  try {
    const response = await queryHuggingFace(imageBuffer);
    if (response) {
      return response;
    } else {
      throw new Error("Error analyzing image");
    }
  } catch (error) {
    console.error("Error analyzing image:", error);
    throw error;
  }
};

module.exports = { analyzeImage };

