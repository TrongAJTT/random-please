# Local API Architecture Design

## 🏗️ Kiến trúc API theo nguyên tắc SOLID

### 1. Single Responsibility Principle (SRP)
- Mỗi API service chỉ chịu tr책nhiệm cho một loại random generator
- HTTP server chỉ chịu trách nhiệm routing và response handling
- Platform detection service chỉ quản lý logic platform-specific

### 2. Open/Closed Principle (OCP)
- API service interfaces có thể mở rộng mà không cần modify existing code
- Dễ dàng thêm mới random generators thông qua interface implementations

### 3. Liskov Substitution Principle (LSP)
- Tất cả random generator services implement cùng một base interface
- Có thể substitute bất kỳ implementation nào mà không ảnh hưởng client

### 4. Interface Segregation Principle (ISP)
- Tách biệt interfaces cho different concerns (generation, configuration, history)
- Client chỉ depend vào interfaces họ thực sự cần

### 5. Dependency Inversion Principle (DIP)
- High-level modules (API endpoints) depend on abstractions (interfaces)
- Low-level modules (concrete generators) implement abstractions

## 📡 API Endpoints Design

### Base URL: `http://localhost:4000/api/v1`

#### Random Generators:
- `GET /random/number` - Generate random numbers
- `GET /random/color` - Generate random colors  
- `GET /random/password` - Generate random passwords
- `GET /random/list-pick` - Pick from lists
- `GET /random/card` - Generate playing cards
- `GET /random/date` - Generate random dates
- `GET /random/lorem` - Generate lorem ipsum
- `GET /random/letter` - Generate latin letters
- `GET /random/coin` - Flip coins
- `GET /random/dice` - Roll dice
- `GET /random/rps` - Rock paper scissors
- `GET /random/yesno` - Yes/No decisions

#### Meta endpoints:
- `GET /info` - API information
- `GET /generators` - List all available generators
- `GET /health` - Health check

## 🔧 Technical Implementation

### Dependencies to add:
```yaml
dependencies:
  shelf: ^1.4.1
  shelf_router: ^1.1.4
  shelf_cors_headers: ^0.1.5
```

### Platform Support:
- ✅ Windows - Full support  
- ✅ Android - Full support with foreground service consideration
- ❌ Web - Disabled (platform detection)