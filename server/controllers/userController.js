const { getClient } = require("../config/database");
const { ObjectId } = require("mongodb");
const bcrypt = require("bcrypt");

async function getAllUsers(req, res) {
  const client = getClient();
  const db = client.db();

  try {
    const users = await db.collection("users").find().toArray();
    res.status(200).send(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).send({ message: "Internal Server Error" });
  }
}

async function getusername(req, res) {
  const client = getClient();
  const db = client.db();

  try {
    const users = await db
      .collection("users")
      .find({}, { projection: { firstName: 1, lastName: 1, _id: 0 } })
      .toArray();
    const modifiedUsers = users.map((user) => ({
      username: `${user.firstName} ${user.lastName}`,
    }));

    res.status(200).send(modifiedUsers);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).send({ message: "Internal Server Error" });
  }
}

async function deleteUser(req, res) {
  const userId = req.params.userId;
  if (!ObjectId.isValid(userId)) {
    return res.status(400).send({ message: "Invalid user ID format." });
  }

  const client = getClient();

  try {
    const db = client.db();
    const result = await db
      .collection("users")
      .deleteOne({ _id: new ObjectId(userId) });

    if (result.deletedCount === 0) {
      return res.status(404).send({ message: "User not found." });
    }

    res.status(200).send({ message: "User deleted successfully." });
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).send({ message: "Internal Server Error." });
  }
}

async function updateUser(req, res) {
  const userId = req.params.userId;
  const { email, password, firstName, lastName } = req.body;

  if (!ObjectId.isValid(userId)) {
    return res.status(400).send({ message: "Invalid user ID format." });
  }

  const updateData = {};

  if (email) updateData.email = email;
  if (password) updateData.password = await hashPassword(password);
  if (firstName) updateData.firstName = firstName;
  if (lastName) updateData.lastName = lastName;

  const client = getClient();

  try {
    const db = client.db();
    const result = await db
      .collection("users")
      .updateOne({ _id: new ObjectId(userId) }, { $set: updateData });

    if (result.matchedCount === 0) {
      return res.status(404).send({ message: "User not found." });
    }

    res.status(200).send({ message: "User updated successfully." });
  } catch (error) {
    console.error("Error updating user:", error);
    res.status(500).send({ message: "Internal Server Error." });
  }
}

async function hashPassword(password) {
  const saltRounds = 10;
  return bcrypt.hash(password, saltRounds);
}

module.exports = {
  getAllUsers,
  getusername,
  deleteUser,
  updateUser,
};
