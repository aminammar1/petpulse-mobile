const { getClient } = require("../config/database");

const getMessages = async (req, reply) => {
  const { username } = req.query;
  const db = getClient().db();
  const messages = await db
    .collection("messages")
    .find({ username })
    .sort({ time: -1 })
    .toArray();
  reply.send(messages);
};
async function storeChatMessage(message) {
  try {
    const client = getClient();
    const db = client.db();
    const messagesCollection = db.collection("messages");
    await messagesCollection.insertOne({ ...message, createdAt: new Date() });
    console.log('Message stored:', message);
  } catch (error) {
    console.error("Error storing chat message:", error);
  }
}

module.exports = {storeChatMessage, getMessages };
