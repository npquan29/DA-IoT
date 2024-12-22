const User = require("../models/User");
const bcrypt = require("bcrypt");

// [POST] /api/v1/auth/login
module.exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Kiểm tra người dùng
    const user = await User.findOne({ where: { username } });
    if (!user) {
      return res
        .status(400)
        .json({
          success: false,
          message: "Incorrect username or password!",
        });
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res
        .status(400)
        .json({
          success: false,
          message: "Incorrect username or password!",
        });
    }

    // Trả về thông tin người dùng (trừ mật khẩu)
    res.json({
      success: true,
      message: "Login successfully!",
      user: {
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        phone: user.phone,
        age: user.age,
      },
    });
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// [POST] /api/v1/auth/register
module.exports.register = async (req, res) => {
  try {
    const { username, fullName, phone, age, password } = req.body;

    // Kiểm tra username đã tồn tại chưa
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) {
      return res.status(400).json({ success: false, message: "Username already exists!" });
    }

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    // Tạo người dùng mới
    const newUser = await User.create({
      username,
      fullName,
      phone,
      age,
      password: hashedPassword,
    });

    res.status(201).json({ success: true, message: "Sign up successfully!", user: newUser });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
