import express from "express";
import cors from "cors";
import path from "path";
import fs from "fs";
import usersRouter from "./api/users/index.js";
import defaultErrHandler from "./errHandler/index.js";
import "./db/index.js";

const app = express();
const port = process.env.PORT;

app.use(cors());
app.use(express.json());
app.use("/accounts", usersRouter);

app.get("/", function (req, res) {
  res.sendFile(path.resolve("./index.html"));
});

app.get("/profile-picture", function (req, res) {
  let img = fs.readFileSync(path.resolve(`./images/${process.env.IMAGE}.jpg`));
  res.writeHead(200, { "Content-Type": "image/jpg" });
  res.end(img, "binary");
});

app.use(defaultErrHandler);

let server = app.listen(port, () => {
  console.info(`Server running at ${port}`);
});
