const User = require("../models/User");

// [PATCH] /api/v1/user/:id
module.exports.edit = async (req, res) => {
  const { id } = req.params; // Lấy id từ URL
  const { fullName, phone, age } = req.body; // Lấy dữ liệu từ request body

  try {
    // Kiểm tra người dùng tồn tại
    const user = await User.findByPk(id);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Cập nhật thông tin người dùng
    await user.update({
      fullName: fullName || user.fullName, // Cập nhật nếu có giá trị mới, giữ nguyên nếu không
      phone: phone || user.phone,
      age: age || user.age,
    });

    // // Trả về thông tin người dùng sau khi cập nhật
    return res.json({
      success: true,
      message: 'User updated successfully!',
      user: {
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        phone: user.phone,
        age: user.age,
      },
    });
  } catch (error) {
    console.error('Error updating user:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while updating the user',
    });
  }
}