const { getClient } = require("../config/database");

async function foodActivity(req, res) {
  try {
    const { food, time, calorie } = req.body;
    const client = getClient();
    const db = client.db();
    const foodCollection = db.collection("pet_food");
    await foodCollection.insertOne({ food, time, calorie });

    return res
      .status(200)
      .send({ success: true, message: "food info added successfully" });
  } catch (error) {
    console.error("Error adding food info:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add food info", error });
  }
}
async function playActivity(req, res) {
  try {
    const { game, time } = req.body;
    const client = getClient();
    const db = client.db();
    const playCollection = db.collection("play_activity");
    await playCollection.insertOne({ game, time });

    return res
      .status(200)
      .send({ success: true, message: "pet play info added successfully" });
  } catch (error) {
    console.error("Error adding play info:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add play info", error });
  }
}
async function sleepActivity(req, res) {
  try {
    const { qualitySleep, timeSleep, timeWakeUp } = req.body;
    const client = getClient();
    const db = client.db();
    const sleepCollection = db.collection("sleep_activity");
    await sleepCollection.insertOne({
      qualitySleep,
      timeSleep,
      timeWakeUp,
      createdAt: new Date(),
    });

    return res
      .status(200)
      .send({ success: true, message: "pet sleep info added successfully" });
  } catch (error) {
    console.error("Error adding sleep info:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add sleep info", error });
  }
}
async function walkActivity(req, res) {
  try {
    const { distance, duration } = req.body;
    const client = getClient();
    const db = client.db();
    const walkCollection = db.collection("walk_activity");
    await walkCollection.insertOne({
      distance,
      duration,
      createdAt: new Date(),
    });

    return res
      .status(200)
      .send({ success: true, message: "Walk info added successfully" });
  } catch (error) {
    console.error("Error adding walk info:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add walk info", error });
  }
}

module.exports = { foodActivity, playActivity, sleepActivity, walkActivity };
