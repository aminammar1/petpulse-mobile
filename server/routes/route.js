const authController = require("../controllers/authController");
const sensorsdataController = require("../controllers/sensors_dataController");
const userController = require("../controllers/userController");
const petController = require("../controllers/petController");
const deviceController = require("../controllers/deviceconfig");
const activityController = require("../controllers/activityController");
const petpicturesController = require("../controllers/savepetpictureController");
const multer = require("fastify-multer");
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });
const chatController = require("../controllers/socketController");
const { analyzeImage } = require("../controllers/emotionmodelController");

const {
  authDocs,
  userDocs,
  deviceDocs,
  petDocs,
  activityDocs,
} = require("../swagger");

async function routes(fastify, options) {
  // Auth routes
  fastify.post("/register", authDocs.register, authController.register);
  fastify.post("/login", authController.login);
  fastify.post("/logout", authDocs.logout, authController.logout);
  fastify.get("/users", userDocs.getAllUsers, userController.getAllUsers);
  fastify.get("/username", userDocs.getusername, userController.getusername);
  fastify.delete("/removeUser/:userId", userController.deleteUser);
  fastify.put("/updateuser/:userId", userController.updateUser);
  fastify.post(
    "/forgotPassword",
    authDocs.forgotPassword,
    authController.forgotPassword
  );
  fastify.post(
    "/verifyResetCode",
    authDocs.verifyResetCode,
    authController.verifyResetCode
  );
  fastify.post(
    "/resetPassword",
    authDocs.resetPassword,
    authController.resetPassword
  );

  // Pet management routes
  fastify.post("/addPetType", petDocs.addPetType, petController.addPetType);
  fastify.post("/addPetInfo", petDocs.addPetInfo, petController.addPetInfo);
  fastify.post(
    "/addPetDetails",
    { preHandler: upload.single("petImage") },
    petController.addPetDetails,
    { schema: petDocs.addPetDetails }
  );
  fastify.delete("/deletePetProfile", petController.deletePetProfile);

  // Device config routes
  fastify.post(
    "/deviceSelect",
    deviceDocs.deviceSelect,
    deviceController.deviceslecet
  );

  // Pet Activity endpoints :
  fastify.post(
    "/foodActivity",
    activityDocs.foodActivity,
    activityController.foodActivity
  );
  fastify.post(
    "/playActivity",
    activityDocs.playActivity,
    activityController.playActivity
  );
  fastify.post(
    "/sleepActivity",
    activityDocs.sleepActivity,
    activityController.sleepActivity
  );
  fastify.post(
    "/walkActivity",
    activityDocs.walkActivity,
    activityController.walkActivity
  );
  // Sensors data endpoints
  fastify.get("/heartrateMeasure", sensorsdataController.heartrateMeasure);
  fastify.get("/temperatureMeasure", sensorsdataController.temperatureMeasure);
  fastify.get("/sleepMeasure", sensorsdataController.sleepMeasure);
  fastify.get("/walkMeasure", sensorsdataController.walkMeasure);

  // save pet pictures :
  fastify.post(
    "/savepetpicture",
    { preHandler: upload.single("image") },
    petpicturesController.savepicture
  );
  fastify.get("/fetchImages", petpicturesController.fetchImages);
  fastify.delete("/image/:id", petpicturesController.deleteImage);

  // Chat routes
  fastify.get("/messages", chatController.getMessages);

  fastify.post("/analyze-image", async (request, reply) => {
    try {
      const imageId = request.body.id;
      if (!imageId) {
        return reply.status(400).send({ error: "Image ID is required" });
      }

      const response = await analyzeImage(imageId);
      reply.send(response);
    } catch (error) {
      console.error("Error analyzing image:", error);
      reply.status(500).send({ error: error.message });
    }
  });
}

module.exports = routes;
