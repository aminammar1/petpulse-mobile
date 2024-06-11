const { getClient } = require("../config/database");

async function deviceslecet(req, res) {
  try {
    const { deviceType } = req.body;

    const client = getClient();
    const db = client.db();
    const device = db.collection("devices");
    await device.insertOne({ type: deviceType });

    return res
      .status(200)
      .send({ success: true, message: "device type added successfully" });
  } catch (error) {
    console.error("Error adding device type:", error);
    return res
      .status(500)
      .send({ success: false, message: "Failed to add device type", error });
  }
}

module.exports = { deviceslecet };
