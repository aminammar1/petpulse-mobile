// swaggerDefinitions.js
const authDocs = {
  register: {
    schema: {
      description: "Register a new user",
      tags: ["auth"],
      summary: "Register user",
      body: {
        type: "object",
        required: ["firstName", "lastName", "email", "password"],
        properties: {
          firstName: { type: "string", description: "First name of the user" },
          lastName: { type: "string", description: "Last name of the user" },
          email: {
            type: "string",
            format: "email",
            description: "Email address of the user",
          },
          password: { type: "string", description: "Password for the account" },
        },
      },
      response: {
        201: {
          description: "User registered successfully",
          type: "object",
          properties: {
            message: { type: "string" },
          },
        },
      },
    },
  },
  login: {
    schema: {
      description: "Login a user",
      tags: ["auth"],
      summary: "Login user",
      body: {
        type: "object",
        required: ["email", "password"],
        properties: {
          email: {
            type: "string",
            format: "email",
            description: "User email address",
          },
          password: { type: "string", description: "User password" },
        },
      },
      response: {
        200: {
          description: "Login successful",
          type: "object",
          properties: {
            message: { type: "string" },
            accessToken: {
              type: "string",
              description: "Access token for authentication",
            },
          },
        },
      },
    },
  },
  forgotPassword: {
    schema: {
      description: "Initiate password reset process",
      tags: ["auth"],
      summary: "Forgot password",
      body: {
        type: "object",
        required: ["email"],
        properties: {
          email: {
            type: "string",
            format: "email",
            description: "User email address",
          },
        },
      },
      response: {
        200: {
          description: "Reset code generated successfully",
          type: "object",
          properties: {
            message: { type: "string" },
            resetCode: { type: "number" },
          },
        },
      },
    },
  },
  verifyResetCode: {
    schema: {
      description: "Verify the validity of the password reset code",
      tags: ["auth"],
      summary: "Verify reset code",
      body: {
        type: "object",
        required: ["code"],
        properties: {
          code: { type: "number", description: "Reset code sent via email" },
        },
      },
      response: {
        200: {
          description: "Reset code verified successfully",
          type: "object",
          properties: {
            message: { type: "string" },
          },
        },
      },
    },
  },
  resetPassword: {
    schema: {
      description: "Reset user's password using a valid reset code",
      tags: ["auth"],
      summary: "Reset password",
      body: {
        type: "object",
        required: ["newPassword", "confirmPassword"],
        properties: {
          newPassword: { type: "string", description: "New password" },
          confirmPassword: {
            type: "string",
            description: "Confirm new password",
          },
        },
      },
      response: {
        200: {
          description: "Password reset successful",
          type: "object",
          properties: {
            message: { type: "string" },
          },
        },
      },
    },
  },
  logout: {
    schema: {
      description: "Logout a user",
      tags: ["auth"],
      summary: "Logout user",
      body: {
        type: "object",
        required: ["refreshToken"],
        properties: {
          refreshToken: { type: "string", description: "Refresh token" },
        },
      },
      response: {
        200: {
          description: "Logout successful",
          type: "object",
          properties: {
            message: { type: "string" },
          },
        },
      },
    },
  },
};

const userDocs = {
  getAllUsers: {
    schema: {
      description: "Get all users",
      tags: ["user"],
      summary: "Get all users",
      response: {
        200: {
          description: "List of all users",
          type: "array",
          items: {
            type: "object",
            properties: {
              _id: { type: "string", description: "User ID" },
              firstName: {
                type: "string",
                description: "First name of the user",
              },
              lastName: {
                type: "string",
                description: "Last name of the user",
              },
              email: {
                type: "string",
                description: "Email address of the user",
              },
              createdAt: {
                type: "string",
                description: "Date when the user was created",
              },
              updateAt: {
                type: "string",
                description: "Date when the user was last updated",
              },
            },
          },
        },
      },
    },
  },
  getusername: {
    schema: {
      description: "Get usernames of all users",
      tags: ["user"],
      summary: "Get usernames of all users",
      response: {
        200: {
          description: "List of usernames",
          type: "array",
          items: {
            type: "object",
            properties: {
              username: {
                type: "string",
                description: "Concatenation of first name and last name",
              },
            },
          },
        },
      },
    },
  },
};
const deviceDocs = {
  deviceSelect: {
    schema: {
      description: "Select a device type",
      tags: ["device"],
      summary: "Select device type",
      body: {
        type: "object",
        required: ["deviceType"],
        properties: {
          deviceType: { type: "string", description: "Type of the device" },
        },
      },
      response: {
        200: {
          description: "Successful response",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
};

const petDocs = {
  addPetType: {
    schema: {
      description: "Add a new pet type",
      tags: ["pet"],
      summary: "Add pet type",
      body: {
        type: "object",
        required: ["petType"],
        properties: {
          petType: { type: "string", description: "Type of the pet" },
        },
      },
      response: {
        200: {
          description: "Pet type added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
  addPetInfo: {
    schema: {
      description: "Add pet information",
      tags: ["pet"],
      summary: "Add pet info",
      body: {
        type: "object",
        required: ["gender", "breed", "weight"],
        properties: {
          gender: { type: "string", description: "Gender of the pet" },
          breed: { type: "string", description: "Breed of the pet" },
          weight: { type: "number", description: "Weight of the pet" },
        },
      },
      response: {
        200: {
          description: "Pet info added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
  addPetDetails: {
    schema: {
      description: "Add pet details and profile",
      tags: ["pet"],
      summary: "Add pet details",
      consumes: ["multipart/form-data"],
      body: {
        type: "object",
        required: ["petName", "birthday", "description"],
        properties: {
          petName: { type: "string", description: "Name of the pet" },
          birthday: {
            type: "string",
            format: "date",
            description: "Birthday of the pet",
          },
          description: {
            type: "string",
            description: "Description of the pet",
          },
        },
      },
      formData: {
        petImage: {
          type: "string",
          format: "binary",
          description: "Image file of the pet",
        },
      },
    },
    response: {
      200: {
        description: "Pet profile added successfully",
        type: "object",
        properties: {
          success: { type: "boolean" },
          message: { type: "string" },
        },
      },
    },
  },
};
const activityDocs = {
  foodActivity: {
    schema: {
      description: "Add food activity for the pet",
      tags: ["activity"],
      summary: "Add food activity",
      body: {
        type: "object",
        required: ["food", "time", "calorie"],
        properties: {
          food: {
            type: "string",
            description: "Type of food consumed by the pet",
          },
          time: {
            type: "string",
            format: "date-time",
            description: "Time of food consumption",
          },
          calorie: {
            type: "number",
            description: "Calories consumed by the pet",
          },
        },
      },
      response: {
        200: {
          description: "Food activity added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
  playActivity: {
    schema: {
      description: "Add play activity for the pet",
      tags: ["activity"],
      summary: "Add play activity",
      body: {
        type: "object",
        required: ["game", "time"],
        properties: {
          game: { type: "string", description: "Game played by the pet" },
          time: {
            type: "string",
            format: "date-time",
            description: "Time of play activity",
          },
        },
      },
      response: {
        200: {
          description: "Play activity added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
  sleepActivity: {
    schema: {
      description: "Add sleep activity for the pet",
      tags: ["activity"],
      summary: "Add sleep activity",
      body: {
        type: "object",
        required: ["qualitySleep", "timeSleep", "timeWakeUp"],
        properties: {
          qualitySleep: {
            type: "string",
            description: "Quality of sleep of the pet",
          },
          timeSleep: {
            type: "string",
            format: "date-time",
            description: "Time when the pet went to sleep",
          },
          timeWakeUp: {
            type: "string",
            format: "date-time",
            description: "Time when the pet woke up",
          },
        },
      },
      response: {
        200: {
          description: "Sleep activity added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
  walkActivity: {
    schema: {
      description: "Add walk activity for the pet",
      tags: ["activity"],
      summary: "Add walk activity",
      body: {
        type: "object",
        required: ["distance", "duration"],
        properties: {
          distance: {
            type: "number",
            description: "Distance covered during the walk",
          },
          duration: {
            type: "number",
            description: "Duration of the walk in minutes",
          },
        },
      },
      response: {
        200: {
          description: "Walk activity added successfully",
          type: "object",
          properties: {
            success: { type: "boolean" },
            message: { type: "string" },
          },
        },
      },
    },
  },
};

module.exports = {
  authDocs,
  deviceDocs,
  userDocs,
  petDocs,
  activityDocs,
};
