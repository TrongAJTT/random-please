# 📋 List Picker API Documentation

## 🎯 Endpoint: `/api/v1/random/list`

API cho phép lựa chọn ngẫu nhiên từ danh sách đã lưu trong Hive hoặc từ danh sách tùy chỉnh.

### 🔧 Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `index` | `int` | No | `0` | Chỉ số của danh sách đã lưu trong Hive (0 = danh sách đầu tiên) |
| `items` | `string` hoặc `array` | No | - | Danh sách tùy chỉnh (ghi đè `index` nếu có) |
| `mode` | `string` | No | `random` | Chế độ: `random`, `shuffle`, `team` |
| `quantity` | `int` | No | `1` | Số lượng mục cần lựa chọn |

### 📝 Modes

#### 1. **`random` mode**
- Lựa chọn ngẫu nhiên `quantity` mục từ danh sách
- `quantity` phải < tổng số mục trong danh sách
- Mặc định: `quantity = 1`

#### 2. **`shuffle` mode** 
- Trộn danh sách và lấy `quantity` mục đầu tiên
- `quantity` phải >= 2 và <= tổng số mục
- Phù hợp để tạo danh sách trộn ngẫu nhiên

#### 3. **`team` mode**
- Chia danh sách thành `quantity` teams ngẫu nhiên
- `quantity` = số lượng teams cần tạo
- Mỗi team sẽ có tên dạng "Team 1: item1, item2, ..."

---

## 🌐 Usage Examples

### **Example 1: Lựa chọn ngẫu nhiên từ danh sách đã lưu**

**Request:**
```bash
GET http://localhost:4000/api/v1/random/list?index=0&mode=random&quantity=2
```

**Response:**
```json
{
  "success": true,
  "data": ["Apple", "Banana"],
  "metadata": {
    "count": 2,
    "mode": "random",
    "list_name": "My Fruits",
    "used_index": 0,
    "used_custom_items": false,
    "config": {
      "index": 0,
      "items": null,
      "mode": "random",
      "quantity": 2
    },
    "generator": "list",
    "version": "1.0.0"
  },
  "error": null,
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

### **Example 2: Sử dụng danh sách tùy chỉnh**

**Request với String:**
```bash
GET http://localhost:4000/api/v1/random/list?items=Red,Green,Blue,Yellow&mode=shuffle&quantity=3
```

**Request với Array (POST):**
```bash
POST http://localhost:4000/api/v1/random/list
Content-Type: application/json

{
  "items": ["Red", "Green", "Blue", "Yellow"],
  "mode": "shuffle", 
  "quantity": 3
}
```

**Response:**
```json
{
  "success": true,
  "data": ["Blue", "Red", "Yellow"],
  "metadata": {
    "count": 3,
    "mode": "shuffle",
    "list_name": "Custom List",
    "used_index": null,
    "used_custom_items": true,
    "config": {
      "index": null,
      "items": ["Red", "Green", "Blue", "Yellow"],
      "mode": "shuffle",
      "quantity": 3
    },
    "generator": "list",
    "version": "1.0.0"
  },
  "error": null,
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

### **Example 3: Tạo teams ngẫu nhiên**

**Request:**
```bash
GET http://localhost:4000/api/v1/random/list?index=1&mode=team&quantity=3
```

**Response:**
```json
{
  "success": true,
  "data": [
    "Team 1: Alice, Bob",
    "Team 2: Charlie, David", 
    "Team 3: Eve, Frank"
  ],
  "metadata": {
    "count": 3,
    "mode": "team",
    "list_name": "Students List",
    "used_index": 1,
    "used_custom_items": false,
    "config": {
      "index": 1,
      "items": null,
      "mode": "team",
      "quantity": 3
    },
    "generator": "list",
    "version": "1.0.0"
  },
  "error": null,
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

---

## 🚨 Error Cases

### **1. Không có danh sách nào trong Hive**
```json
{
  "success": false,
  "data": null,
  "error": "No lists available in the application. Please create a list first.",
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

### **2. Index vượt quá số lượng danh sách**
```json
{
  "success": false,
  "data": null,
  "error": "Invalid configuration for list picker generator",
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

### **3. Quantity không hợp lệ cho mode**
```json
{
  "success": false,
  "data": null,
  "error": "Invalid quantity for random mode with 5 items",
  "timestamp": 1727123456789,
  "version": "1.0.0"
}
```

---

## 🔗 Try It Links

### **Quick Test Examples:**

1. **Random từ list đầu tiên:**
   ```
   http://localhost:4000/api/v1/random/list?mode=random&quantity=1
   ```
   [🔗 Try it!](http://localhost:4000/api/v1/random/list?mode=random&quantity=1)

2. **Shuffle 3 items từ list thứ 2:**
   ```
   http://localhost:4000/api/v1/random/list?index=1&mode=shuffle&quantity=3
   ```
   [🔗 Try it!](http://localhost:4000/api/v1/random/list?index=1&mode=shuffle&quantity=3)

3. **Tạo 2 teams từ custom list:**
   ```
   http://localhost:4000/api/v1/random/list?items=A,B,C,D,E,F&mode=team&quantity=2
   ```
   [🔗 Try it!](http://localhost:4000/api/v1/random/list?items=A,B,C,D,E,F&mode=team&quantity=2)

4. **Custom items shuffle:**
   ```
   http://localhost:4000/api/v1/random/list?items=Apple,Banana,Cherry,Date&mode=shuffle&quantity=2
   ```
   [🔗 Try it!](http://localhost:4000/api/v1/random/list?items=Apple,Banana,Cherry,Date&mode=shuffle&quantity=2)

---

## 📊 Validation Rules

### **Random Mode:**
- `quantity > 0`
- `quantity < total_items`

### **Shuffle Mode:**
- `quantity >= 2` 
- `quantity <= total_items`

### **Team Mode:**
- `quantity >= 2` (tối thiểu 2 teams)
- `total_items >= 3` (tối thiểu 3 items để chia team)
- `quantity <= (total_items / 2)` (mỗi team có ít nhất 1 thành viên)

---

## 🔍 Implementation Details

- **Hive Box:** `listPickerGeneratorBox`
- **State Model:** `ListPickerGeneratorState`
- **Data Priority:** `items` parameter ghi đè `index` parameter
- **Default Behavior:** Sử dụng list đầu tiên (`index=0`) với `mode=random`, `quantity=1`
- **Thread Safety:** Hive operations are async-safe
- **Error Handling:** Graceful degradation với thông báo lỗi rõ ràng

---

*📚 Để biết thêm thông tin về các API khác, xem [LOCAL_API_IMPLEMENTATION.md](LOCAL_API_IMPLEMENTATION.md)*