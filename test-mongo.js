const mongoose = require("mongoose");

const MONGO_URI = "mongodb+srv://mongouser:mongodb123@terraform-ecd-nodejs-m.4d0dikf.mongodb.net/appdb";

mongoose.connect(MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => {
  console.log("✅ MongoDB connected successfully");
  process.exit(0);
})
.catch(err => {
  console.error("❌ MongoDB connection failed");
  console.error(err.message);
  process.exit(1);
});
