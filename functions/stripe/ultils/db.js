const {getFirestore, FieldValue} = require("firebase-admin/firestore");

const db = getFirestore();

module.exports = {db, FieldValue};
