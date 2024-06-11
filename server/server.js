require("dotenv").config();
const fastify = require("fastify")({
  logger: {
    transport: {
      target: "pino-pretty",
    },
  },
});
const { connectDB } = require("./config/database");
const routes = require("./routes/route");
const multer = require("fastify-multer");
const fastifySwagger = require("@fastify/swagger");
const fastifySwaggerUi = require("@fastify/swagger-ui");
const socketio = require("socket.io");
const { storeChatMessage } = require("./controllers/socketController");

fastify.register(multer.contentParser);

const PORT = process.env.PORT || 3000;

fastify.register(fastifySwagger, {
  openapi: {
    info: {
      title: "PetPulse API",
      description: "PetPulse API Documentation",
      version: "1.0.0",
    },
    servers: [
      {
        url: "http://localhost:3000",
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
        },
      },
    },
    tags: [
      {
        name: "Root",
        description: "Root endpoints",
      },
    ],
  },
});

fastify.register(fastifySwaggerUi, {
  routePrefix: "/documentation",
  uiConfig: {
    docExpansion: "full",
    deepLinking: false,
  },
  uiHooks: {
    onRequest: function (_request, _reply, next) {
      next();
    },
    preHandler: function (_request, _reply, next) {
      next();
    },
  },
  staticCSP: true,
  transformStaticCSP: (header) => header,
  transformSpecification: (swaggerObject) => {
    return swaggerObject;
  },
  transformSpecificationClone: true,
});

const startServer = async () => {
  try {
    await connectDB();
    fastify.log.info("Connected to MongoDB");

    fastify.register(routes, { prefix: "/api" });
    await fastify.listen({ port: PORT, host: "0.0.0.0" });
    console.log(`Server is running on http://0.0.0.0:${PORT}`);

    const io = socketio(fastify.server, {
      cors: {
        origin: "*",
        methods: ["GET", "POST"],
      },
    });
    const users = {};

    io.on("connection", (socket) => {
      socket.on("joinRoom", (username) => {
        socket.leaveAll();
        socket.join(username);
        users[socket.id] = username;
        console.log(`${username} joined room`);
      });

      socket.on("sendMessage", async (msg) => {
        console.log("Message received on server:", msg);

        try {
          await storeChatMessage(msg);
        } catch (error) {
          console.error("Error storing message:", error);
        }

        const userRoom = users[socket.id];
        if (!userRoom) return;

        io.to(userRoom).emit("receiveMessage", {
          ...msg,
          timestamp: new Date().toISOString(),
        });

        const responseMessage = {
          message: "hello",
          username: "Server",
          userImage: "",
          isMe: false,
          isOnline: true,
          imageUrl: "",
          timestamp: new Date().toISOString(),
        };

        io.to(userRoom).emit("receiveMessage", responseMessage);
        console.log("Response message sent by server:", responseMessage);
      });

      socket.on("disconnect", () => {
        const username = users[socket.id];
        delete users[socket.id];
        console.log(`${username} disconnected`);
      });
    });
  } catch (err) {
    console.error("Error starting server:", err);
    process.exit(1);
  }
};

startServer();
