const { getClient } = require("../config/database");

async function heartrateMeasure(req, res) {
  try {
    const client = getClient();
    const db = client.db();
    const heartRateCollection = db.collection("sensors");

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const avgHeartRate = await heartRateCollection
      .aggregate([
        {
          $match: {
            heartbeat: { $exists: true },
            createdAt: {
              $gte: today.toISOString(),
              $lt: tomorrow.toISOString(),
            },
          },
        },
        { $group: { _id: null, avgValue: { $avg: "$heartbeat" } } },
        { $project: { _id: 0, avgValue: 1 } },
      ])
      .toArray();

    if (avgHeartRate.length === 0) {
      return res.status(404).send({
        success: false,
        message: "No heart rate data found for today",
      });
    }

    return res.status(200).send({
      success: true,
      message: "Average heart rate fetched successfully",
      data: avgHeartRate[0],
    });
  } catch (error) {
    console.error("Error fetching average heart rate:", error);
    return res.status(500).send({
      success: false,
      message: "Failed to fetch average heart rate",
      error,
    });
  }
}

async function temperatureMeasure(req, res) {
  try {
    const client = getClient();
    const db = client.db();
    const temperatureCollection = db.collection("sensors");

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const avgTemperature = await temperatureCollection
      .aggregate([
        {
          $match: {
            temperature: { $exists: true },
            createdAt: {
              $gte: today.toISOString(),
              $lt: tomorrow.toISOString(),
            },
          },
        },
        { $group: { _id: null, avgValue: { $avg: "$temperature" } } },
        { $project: { _id: 0, avgValue: 1 } },
      ])
      .toArray();

    return res.status(200).send({
      success: true,
      message: "Average temperature fetched successfully",
      data: avgTemperature[0],
    });
  } catch (error) {
    console.error("Error fetching average temperature:", error);
    return res.status(500).send({
      success: false,
      message: "Failed to fetch average temperature",
      error,
    });
  }
}

async function sleepMeasure(req, res) {
  try {
    const client = getClient();
    const db = client.db();
    const sleepCollection = db.collection("sleep_activity");

    const offset = 0;
    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    today.setMinutes(today.getMinutes() + offset);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const pipeline = [
      {
        $match: {
          createdAt: {
            $gte: today,
            $lt: tomorrow,
          },
        },
      },
      {
        $addFields: {
          sleepDurationHours: {
            $divide: [
              {
                $subtract: [
                  { $toDate: "$timeWakeUp" },
                  { $toDate: "$timeSleep" },
                ],
              },
              1000 * 60 * 60,
            ],
          },
        },
      },
      {
        $group: {
          _id: null,
          avgSleepDurationHours: { $avg: "$sleepDurationHours" },
        },
      },
      {
        $project: {
          _id: 0,
          avgSleepDurationHours: 1,
        },
      },
    ];

    const result = await sleepCollection.aggregate(pipeline).toArray();

    if (result.length === 0 || result[0].avgSleepDurationHours === null) {
      return res.status(404).send({
        success: false,
        message: "No valid sleep activities found",
      });
    }

    const { avgSleepDurationHours } = result[0];

    return res.status(200).send({
      success: true,
      message: "Average sleep activity fetched successfully",
      data: { avgSleepDurationHours },
    });
  } catch (error) {
    console.error("Error fetching average sleep activity:", error);
    return res.status(500).send({
      success: false,
      message: "Failed to fetch average sleep activity",
      error,
    });
  }
}

async function walkMeasure(req, res) {
  try {
    const client = getClient();
    const db = client.db();
    const walkCollection = db.collection("walk_activity");

    const offset = 0;
    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    today.setMinutes(today.getMinutes() + offset);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const avgWalk = await walkCollection
      .aggregate([
        {
          $match: {
            distance: { $exists: true },
            createdAt: {
              $gte: today,
              $lt: tomorrow,
            },
          },
        },
        { $group: { _id: null, avgValue: { $avg: "$distance" } } },
        { $project: { _id: 0, avgValue: 1 } },
      ])
      .toArray();

    if (avgWalk.length === 0) {
      return res.status(404).send({
        success: false,
        message: "No walk activity data found for today",
      });
    }

    return res.status(200).send({
      success: true,
      message: "Average walk activity fetched successfully",
      data: avgWalk[0],
    });
  } catch (error) {
    console.error("Error fetching average walk activity:", error);
    return res.status(500).send({
      success: false,
      message: "Failed to fetch average walk activity",
      error,
    });
  }
}

module.exports = {
  heartrateMeasure,
  temperatureMeasure,
  sleepMeasure,
  walkMeasure,
};
