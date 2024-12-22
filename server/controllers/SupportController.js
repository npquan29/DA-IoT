const SupportData = require('../models/SupportData');

// Hàm lấy tất cả các giá trị từ bảng SupportData
exports.getAllSupportData = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1; 
    const limit = parseInt(req.query.pageSize) || 10;
    const offset = (page - 1) * limit;

    const {rows, count} = await SupportData.findAndCountAll({
      limit, 
      offset, 
      order: [["createdAt", "DESC"]]
    });

    res.status(200).json({data: rows, total: count}); // Trả về dữ liệu dưới dạng JSON
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).json({ message: "Error fetching data" });
  }
};