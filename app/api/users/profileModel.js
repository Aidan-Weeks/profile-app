import mongoose from 'mongoose';

const Schema = mongoose.Schema;
 
const ProfileSchema = new Schema({
  userid: { type: Number, required: true, unique: true },
  email: { type: String },
  name: { type: String },
  interests: { type: String },

});

ProfileSchema.statics.findByUserId = function (id) {
  return this.findOne({ userid: id });
};

export default mongoose.model('users', ProfileSchema);


