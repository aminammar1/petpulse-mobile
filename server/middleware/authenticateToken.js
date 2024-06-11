const jwt = require("jsonwebtoken");

function authenticateToken(req, res, next) {
  const token = req.headers.authorization?.split(" ")[1]; // "Bearer TOKEN"
  if (!token)
    return res.status(401).send({ message: "Access token not provided" });

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) {
      const message =
        err.name === "TokenExpiredError"
          ? "Access token expired"
          : "Invalid access token";
      return res.status(403).send({ message });
    }
    req.user = user;
    next();
  });
}

module.exports = authenticateToken;
