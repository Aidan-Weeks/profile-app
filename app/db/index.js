import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

let mongo_url = `mongodb://${process.env.MONGO_USER}:${process.env.MONGO_PASS}@${process.env.MONGO_HOST}:${process.env.MONGO_PORT}`;
console.log(mongo_url)

mongoose.connect(mongo_url, {
  dbName: "user-account",
});
const db = mongoose.connection;

db.on("error", (err) => {
  console.log(`database connection error: ${err}`);
});
db.on("disconnected", () => {
  console.log("database disconnected");
});
db.once("open", () => {
  console.log(`database connected to ${db.name} on ${db.host}`);
});
