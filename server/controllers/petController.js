const { getClient } = require("../config/database");

async function addPetType(req, res) {
  try {
    const { petType } = req.body;

    const client = getClient();
    const db = client.db();
    const petCollection = db.collection("pet");
    await petCollection.insertOne({ type: petType });

    return res
      .status(200)
      .send({ success: true, message: "Pet type added successfully" });
  } catch (error) {
    console.error("Error adding pet type:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add pet type", error });
  }
}

async function addPetInfo(req, res) {
  try {
    const { gender, breed, weight } = req.body;
    const client = getClient();
    const db = client.db();
    const petCollection = db.collection("pet");
    await petCollection.insertOne({ gender, breed, weight });

    return res
      .status(200)
      .send({ success: true, message: "Pet info added successfully" });
  } catch (error) {
    console.error("Error adding pet info:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add pet info", error });
  }
}

async function addPetDetails(req, res) {
  try {
    const { petName, birthday, description } = req.body;
    const petImage = req.file;

    if (!petImage) {
      return res
        .status(400)
        .send({ success: false, message: "No pet image provided" });
    }

    const client = getClient();
    const db = client.db();
    const petCollection = db.collection("pet");

    const latestPetType = await petCollection.findOne(
      { type: { $exists: true } },
      { sort: { _id: -1 } }
    );

    if (!latestPetType) {
      return res
        .status(400)
        .send({ success: false, message: "Pet type data not found" });
    }

    const latestPetInfo = await petCollection.findOne(
      {
        gender: { $exists: true },
        breed: { $exists: true },
        weight: { $exists: true },
      },
      { sort: { _id: -1 } }
    );
    const newPetProfile = {
      petType: latestPetType.type,
      gender: latestPetInfo.gender,
      breed: latestPetInfo.breed,
      weight: latestPetInfo.weight,
      petName,
      birthday,
      description,
      petImage: petImage.buffer,
    };

    const profilesCollection = db.collection("Petprofile");
    await profilesCollection.insertOne(newPetProfile);
    await petCollection.drop();

    return res
      .status(200)
      .send({ success: true, message: "Pet profile added successfully" });
  } catch (error) {
    console.error("Error adding pet profile:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add pet profile", error });
  }
}
async function deletePetProfile(req, res) {
  try {
    const { petName } = req.body;

    const client = getClient();
    const db = client.db();
    const profilesCollection = db.collection("Petprofile");

    const result = await profilesCollection.deleteOne({ petName });

    if (result.deletedCount === 0) {
      return res.status(404).send({ success: false, message: "Pet profile not found" });
    }

    return res.status(200).send({ success: true, message: "Pet profile deleted successfully" });
  } catch (error) {
    console.error("Error deleting pet profile:", error);
    return res.status(500).send({ success: false, message: "Failed to delete pet profile", error });
  }
}

module.exports = { addPetType, addPetInfo, addPetDetails,deletePetProfile };
