import asyncHandler from "express-async-handler";
import express from "express";
import Profile from "./profileModel.js";

const router = express.Router();

router.get(
  "/profile",
  asyncHandler(async (req, res) => {
    let myquery = { userid: 1 };
    const profile = await Profile.findByUserId(1);
    if (profile) {
      res.status(200).json(profile);
    } else {
      res
        .status(404)
        .json({
          message: "The user you requested could not be found.",
          status_code: 404,
        });
    }
  })
);

router.post(
  "/profile",
  asyncHandler(async (req, res) => {
    let userObj = req.body;
    userObj["userid"] = 1;

    let myquery = { userid: 1 };
    let newvalues = { $set: userObj };

    await Profile.updateOne(myquery, newvalues, { upsert: true });
  })
);
export default router;
