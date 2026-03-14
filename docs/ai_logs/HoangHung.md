Shopee Simulator
1. Introduction
Trong thời đại thương mại điện tử phát triển mạnh mẽ, các nền tảng như Shopee đã trở thành một trong những hệ thống mua sắm trực tuyến lớn nhất tại khu vực Đông Nam Á. Với hàng triệu sản phẩm được đăng bán mỗi ngày, việc nghiên cứu, phân tích dữ liệu sản phẩm và tự động hóa các quy trình mua sắm ngày càng trở nên quan trọng đối với các nhà phát triển phần mềm và các nhà nghiên cứu dữ liệu.
Shopee Simulator là một công cụ được thiết kế để mô phỏng các hành vi của người dùng trên hệ thống Shopee. Công cụ này cho phép lập trình viên kiểm tra các chức năng như tìm kiếm sản phẩm, xem chi tiết sản phẩm, lấy dữ liệu giá, thêm sản phẩm vào giỏ hàng hoặc phân tích xu hướng giá mà không cần phải thực hiện các thao tác thủ công trên giao diện trình duyệt.
Mục tiêu chính của Shopee Simulator là tạo ra một môi trường thử nghiệm (testing environment) để các nhà phát triển có thể kiểm tra các thuật toán, bot tự động hoặc hệ thống thu thập dữ liệu một cách hiệu quả. Điều này đặc biệt hữu ích trong các lĩnh vực như web automation, data crawling, price monitoring, và market analysis.
2. Purpose of Shopee Simulator
Shopee Simulator có nhiều mục đích sử dụng trong lĩnh vực phát triển phần mềm và phân tích dữ liệu.
Thứ nhất, simulator giúp lập trình viên mô phỏng hành vi người dùng như tìm kiếm sản phẩm hoặc xem thông tin sản phẩm. Điều này cho phép kiểm thử hệ thống tự động mà không cần phải thao tác trực tiếp trên website.
Thứ hai, simulator có thể được sử dụng để thu thập dữ liệu sản phẩm như tên sản phẩm, giá, đánh giá và số lượng bán ra. Những dữ liệu này có thể được sử dụng để phân tích xu hướng thị trường hoặc xây dựng các hệ thống so sánh giá.
Thứ ba, simulator giúp kiểm tra hiệu suất của các thuật toán tự động. Ví dụ, một bot có thể được thiết kế để tự động tìm sản phẩm có giá thấp nhất hoặc theo dõi sự thay đổi giá theo thời gian.
Nhờ khả năng mô phỏng các request giống với trình duyệt thật, Shopee Simulator có thể gửi các yêu cầu HTTP tới server của Shopee và nhận lại dữ liệu ở dạng JSON. Sau đó dữ liệu này có thể được xử lý bằng các ngôn ngữ lập trình như Python, JavaScript hoặc Java.
3. How Shopee Simulator Works
Shopee Simulator hoạt động dựa trên nguyên lý gửi các HTTP request đến các API endpoint của Shopee. Khi người dùng tìm kiếm sản phẩm trên Shopee, trình duyệt sẽ gửi một request đến server để lấy danh sách sản phẩm phù hợp với từ khóa tìm kiếm. Simulator sẽ mô phỏng chính request này.
Quá trình hoạt động cơ bản của Shopee Simulator bao gồm các bước sau:
Người dùng nhập từ khóa tìm kiếm (ví dụ: laptop, iphone, tai nghe).
Simulator gửi request HTTP đến API tìm kiếm của Shopee.
Server của Shopee trả về dữ liệu sản phẩm dưới dạng JSON.
Simulator xử lý dữ liệu và hiển thị thông tin sản phẩm.
Thông tin sản phẩm có thể bao gồm:
Tên sản phẩm
Giá sản phẩm
Số lượng đã bán
Đánh giá của người dùng
Thông tin shop
Những dữ liệu này sau đó có thể được sử dụng cho nhiều mục đích khác nhau như phân tích dữ liệu hoặc xây dựng hệ thống khuyến nghị sản phẩm.
4. Example Code (Python)
Dưới đây là một ví dụ đơn giản về cách xây dựng một Shopee Simulator bằng Python để tìm kiếm sản phẩm trên Shopee.
import requests

url = "https://shopee.vn/api/v4/search/search_items"

params = {
    "by": "relevancy",
    "keyword": "laptop",
    "limit": 10,
    "newest": 0,
    "order": "desc",
    "page_type": "search"
}

headers = {
    "User-Agent": "Mozilla/5.0",
    "Accept": "application/json"
}

response = requests.get(url, params=params, headers=headers)

data = response.json()

for item in data["items"]:
    product = item["item_basic"]["name"]
    price = item["item_basic"]["price"] / 100000
    sold = item["item_basic"]["historical_sold"]

    print("Product:", product)
    print("Price:", price, "VND")
    print("Sold:", sold)
    print("----------------------")
5. Code Explanation
Trong đoạn code trên, thư viện requests được sử dụng để gửi HTTP request đến API của Shopee.
url là endpoint API được dùng để tìm kiếm sản phẩm.
params chứa các tham số tìm kiếm như từ khóa (keyword) và số lượng sản phẩm cần trả về (limit).
headers mô phỏng thông tin của trình duyệt để server nhận diện request giống như request từ người dùng thật.
Sau khi gửi request, server sẽ trả về dữ liệu ở dạng JSON. Chương trình sẽ đọc dữ liệu này và trích xuất các thông tin như tên sản phẩm, giá và số lượng đã bán.
Nhờ cách này, simulator có thể tự động thu thập thông tin sản phẩm mà không cần mở website bằng trình duyệt.
6. Advantages of Shopee Simulator
Shopee Simulator mang lại nhiều lợi ích cho lập trình viên và nhà phân tích dữ liệu.
Thứ nhất, nó giúp tiết kiệm thời gian khi thu thập dữ liệu sản phẩm từ Shopee. Thay vì phải tìm kiếm thủ công từng sản phẩm, simulator có thể tự động thu thập hàng trăm hoặc hàng nghìn sản phẩm trong thời gian ngắn.
Thứ hai, simulator cho phép kiểm thử các thuật toán tự động trong môi trường mô phỏng. Điều này giúp giảm rủi ro khi triển khai các hệ thống automation trong thực tế.
Thứ ba, simulator có thể được tích hợp vào các hệ thống phân tích dữ liệu lớn để theo dõi xu hướng giá hoặc dự đoán nhu cầu thị trường.
7. Conclusion
Shopee Simulator là một công cụ hữu ích trong việc nghiên cứu và phát triển các hệ thống tự động liên quan đến thương mại điện tử. Bằng cách mô phỏng hành vi người dùng và gửi các request HTTP tới API của Shopee, simulator cho phép lập trình viên thu thập dữ liệu sản phẩm, kiểm thử thuật toán và xây dựng các hệ thống phân tích thị trường.
Trong tương lai, các công cụ mô phỏng như Shopee Simulator có thể được phát triển thêm để hỗ trợ nhiều chức năng phức tạp hơn, chẳng hạn như mô phỏng quá trình mua hàng hoàn chỉnh, theo dõi sự thay đổi giá theo thời gian hoặc xây dựng các hệ thống khuyến nghị sản phẩm thông minh.
Phân tích lỗi đăng nhập trong hệ thống
Sau khi kiểm tra quá trình đăng ký và đăng nhập của hệ thống, có thể xác định nguyên nhân khiến người dùng đăng nhập không thành công nằm ở sự không đồng nhất trong quá trình xử lý mật khẩu.
Trong chức năng đăng ký tài khoản (Register), mật khẩu người dùng nhập vào đã được mã hóa bằng thuật toán MD5 trước khi lưu vào cơ sở dữ liệu. Điều này có nghĩa là trong bảng database, giá trị được lưu trữ không phải là mật khẩu gốc mà là chuỗi hash MD5 của mật khẩu.
Tuy nhiên, trong chức năng đăng nhập (Login), chương trình lại lấy trực tiếp mật khẩu người dùng nhập từ form và truyền thẳng vào hàm login() trong UserDAO để so sánh với dữ liệu trong database. Do mật khẩu trong database đã được mã hóa, còn mật khẩu gửi từ form lại là dạng văn bản gốc (plain text), nên hai giá trị này không bao giờ trùng nhau. Vì vậy truy vấn SQL dạng:
SELECT * FROM Users 
WHERE email = ? AND password_hash = ?
luôn trả về kết quả rỗng, khiến hệ thống xác định đăng nhập thất bại.
Cách khắc phục
Để giải quyết vấn đề này, cần đảm bảo rằng mật khẩu khi đăng nhập cũng phải được mã hóa bằng cùng thuật toán MD5 trước khi so sánh với dữ liệu trong database.
Cụ thể, trong LoginServlet, sau khi nhận mật khẩu từ form:
String p = request.getParameter("pass");
ta cần gọi hàm mã hóa MD5 để tạo ra chuỗi hash tương ứng:
String passHash = getMd5(p);
Sau đó truyền giá trị passHash vào phương thức login() thay vì truyền mật khẩu gốc:
User account = dao.login(u, passHash);
Như vậy, mật khẩu được dùng để so sánh với database sẽ có cùng định dạng (đều là MD5), giúp hệ thống xác thực người dùng chính xác.
Một số điểm cần kiểm tra thêm
Ngoài lỗi chính về mã hóa mật khẩu, còn một số yếu tố có thể gây lỗi đăng nhập:
Tên tham số trong form JSP
Trong login.jsp, các ô nhập liệu phải có thuộc tính name trùng với tên được lấy trong Servlet. Ví dụ:
<input type="text" name="user">
<input type="password" name="pass">
Nếu tên này không khớp với:
request.getParameter("user");
request.getParameter("pass");
thì dữ liệu nhận được sẽ là null.
Thư viện Servlet phải đồng nhất
Dự án cần sử dụng cùng một chuẩn thư viện:
Nếu dùng Tomcat 9 trở xuống → javax.servlet
Nếu dùng Tomcat 10 trở lên → jakarta.servlet
Việc trộn lẫn hai thư viện này có thể khiến server báo lỗi hoặc servlet không hoạt động đúng.
Kết luận
Nguyên nhân chính khiến hệ thống không đăng nhập được là do mật khẩu khi đăng nhập chưa được mã hóa trước khi so sánh với dữ liệu đã mã hóa trong database. Sau khi bổ sung bước mã hóa MD5 trong LoginServlet và kiểm tra lại tên tham số trong form, chức năng đăng nhập sẽ hoạt động bình thường.

Trong quá trình kiểm tra chức năng đăng nhập của hệ thống, có thể nhận thấy rằng người dùng đã đăng ký tài khoản thành công nhưng lại không thể đăng nhập vào hệ thống. Sau khi xem xét các thành phần liên quan như RegisterServlet, LoginServlet, UserDAO và dữ liệu trong database, nguyên nhân chính của lỗi này được xác định là sự không nhất quán trong quá trình xử lý mật khẩu giữa chức năng đăng ký và đăng nhập.
1. Cách hệ thống xử lý mật khẩu khi đăng ký
Trong chức năng đăng ký tài khoản, khi người dùng nhập mật khẩu vào form đăng ký, hệ thống không lưu trực tiếp mật khẩu gốc vào cơ sở dữ liệu. Thay vào đó, chương trình sử dụng thuật toán băm MD5 để chuyển mật khẩu sang dạng chuỗi hash trước khi lưu trữ.
Quá trình này thường được thực hiện thông qua một hàm như sau:

private String getMd5(String input)
Hàm này sử dụng lớp MessageDigest của Java để tạo ra giá trị MD5 của chuỗi đầu vào. Sau khi mật khẩu được băm, hệ thống sẽ lưu chuỗi hash này vào database thay vì mật khẩu gốc.
Ví dụ:

Người dùng nhập mật khẩu:
123
Sau khi mã hóa MD5:
202cb962ac59075b964b07152d234b70
Chuỗi MD5 này sẽ được lưu trong cột password_hash của bảng Users.
Việc sử dụng cơ chế hash mật khẩu giúp tăng mức độ bảo mật cho hệ thống, vì ngay cả khi database bị truy cập trái phép, hacker cũng không thể nhìn thấy mật khẩu gốc của người dùng.

2. Lỗi xảy ra trong chức năng đăng nhập
Trong chức năng đăng nhập, hệ thống nhận thông tin từ form login.jsp, bao gồm:
Tên đăng nhập hoặc email
Mật khẩu
Dữ liệu này được gửi tới LoginServlet thông qua phương thức POST. Sau đó, servlet sẽ lấy dữ liệu từ request bằng cách sử dụng:
String u = request.getParameter("user");
String p = request.getParameter("pass");
Vấn đề nằm ở chỗ: mật khẩu p ở đây vẫn là mật khẩu gốc do người dùng nhập, chưa được mã hóa. Tuy nhiên trong database, mật khẩu đã được lưu dưới dạng chuỗi MD5.
Sau đó chương trình gọi hàm:

User account = dao.login(u, p);
Trong UserDAO, phương thức login() thường thực hiện truy vấn SQL như sau:
SELECT * FROM Users 
WHERE email = ? AND password_hash = ?
Do giá trị p là mật khẩu gốc (ví dụ: 123), trong khi database lưu 202cb962ac59075b964b07152d234b70, nên hai giá trị này không bao giờ trùng nhau. Kết quả là truy vấn SQL không tìm thấy bản ghi phù hợp và trả về null.
Vì vậy, hệ thống luôn cho rằng tài khoản hoặc mật khẩu không chính xác, dù người dùng nhập đúng thông tin.

3. Giải pháp khắc phục
Để khắc phục lỗi này, cần đảm bảo rằng mật khẩu nhập vào trong quá trình đăng nhập được mã hóa bằng cùng thuật toán MD5 trước khi thực hiện truy vấn database.
Trong LoginServlet, sau khi nhận mật khẩu từ request, cần thêm bước mã hóa:

String passHash = getMd5(p);
Sau đó truyền giá trị đã mã hóa vào DAO:
User account = dao.login(u, passHash);
Như vậy quá trình so sánh sẽ diễn ra giữa hai chuỗi MD5 giống nhau, giúp hệ thống xác thực chính xác tài khoản người dùng.
Quy trình đăng nhập sau khi sửa sẽ hoạt động như sau:

Người dùng nhập email và mật khẩu.
Servlet nhận dữ liệu từ form.
Mật khẩu được mã hóa bằng MD5.
Hệ thống gửi email và chuỗi MD5 đến UserDAO.
Database kiểm tra dữ liệu.
Nếu tồn tại bản ghi phù hợp → đăng nhập thành công.
4. Kiểm tra sự khớp giữa form JSP và Servlet
Một vấn đề khác có thể gây lỗi là tên tham số trong form không khớp với Servlet.
Trong file login.jsp, form nhập liệu được định nghĩa như sau:

<input type="text" name="user">
<input type="password" name="pass">
Do đó trong Servlet phải lấy đúng tên tham số:
request.getParameter("user");
request.getParameter("pass");
Nếu JSP sử dụng tên khác (ví dụ email hoặc password), thì biến nhận dữ liệu trong Servlet sẽ bị null, dẫn đến đăng nhập thất bại.
5. Kiểm tra phiên bản thư viện Servlet
Một lỗi tiềm ẩn khác liên quan đến sự không đồng nhất giữa thư viện javax.servlet và jakarta.servlet.
Nếu project chạy trên Tomcat 9 hoặc thấp hơn, phải dùng:
import javax.servlet.*;
Nếu project chạy trên Tomcat 10 trở lên, phải dùng:
import jakarta.servlet.*;
Việc sử dụng lẫn lộn hai thư viện này có thể gây ra lỗi server hoặc khiến servlet không được nhận diện.
6. Kết luận
Nguyên nhân chính khiến hệ thống không thể đăng nhập là do mật khẩu được mã hóa khi đăng ký nhưng lại không được mã hóa khi đăng nhập, dẫn đến sự sai lệch trong quá trình so sánh dữ liệu với database.
Sau khi bổ sung bước mã hóa MD5 trong LoginServlet, đồng thời kiểm tra lại tên tham số trong form JSP và đảm bảo sử dụng đúng thư viện Servlet, chức năng đăng nhập sẽ hoạt động chính xác.

Việc áp dụng cơ chế hash mật khẩu không chỉ giúp hệ thống hoạt động đúng mà còn nâng cao mức độ bảo mật cho ứng dụng web, bảo vệ thông tin người dùng trước các rủi ro về an toàn dữ liệu.
Phân tích chi tiết cơ chế đăng nhập và lỗi xác thực mật khẩu trong hệ thống Web
1. Tổng quan về chức năng đăng nhập trong ứng dụng web
Trong hầu hết các hệ thống thương mại điện tử như Shopee, Lazada hoặc Amazon, chức năng đăng ký và đăng nhập tài khoản là một trong những thành phần quan trọng nhất của hệ thống. Nó cho phép hệ thống xác định danh tính của người dùng và cung cấp các chức năng cá nhân hóa như quản lý giỏ hàng, đặt hàng, thanh toán và theo dõi đơn hàng.
Trong project web mô phỏng Shopee, quá trình đăng nhập được xây dựng dựa trên mô hình Java Web Application, bao gồm các thành phần chính:
Frontend (JSP/HTML/CSS/JS): giao diện cho người dùng nhập thông tin
Servlet (Controller): xử lý request từ người dùng
DAO (Data Access Object): giao tiếp với cơ sở dữ liệu
Database: lưu trữ thông tin người dùng
Quá trình đăng nhập thông thường sẽ trải qua các bước sau:
Người dùng nhập email (hoặc username) và mật khẩu vào form đăng nhập.
Form gửi dữ liệu đến LoginServlet thông qua phương thức POST.
Servlet nhận dữ liệu và xử lý logic xác thực.
Servlet gọi UserDAO để kiểm tra thông tin trong database.
Nếu dữ liệu hợp lệ, hệ thống tạo Session để lưu trạng thái đăng nhập.
Người dùng được chuyển hướng đến trang chủ.
Tuy nhiên, trong hệ thống hiện tại đã xuất hiện lỗi khiến người dùng không thể đăng nhập dù đã đăng ký thành công.
2. Phân tích nguyên nhân gây lỗi đăng nhập
Sau khi kiểm tra mã nguồn của RegisterServlet, LoginServlet và cấu trúc database, có thể xác định nguyên nhân chính là sự không đồng bộ trong cách xử lý mật khẩu giữa hai chức năng đăng ký và đăng nhập.
2.1 Mật khẩu được mã hóa khi đăng ký
Trong chức năng đăng ký, hệ thống đã áp dụng thuật toán băm MD5 để mã hóa mật khẩu trước khi lưu vào database.
Ví dụ:
Người dùng nhập mật khẩu:
123456
Sau khi áp dụng thuật toán MD5, mật khẩu sẽ trở thành:
e10adc3949ba59abbe56e057f20f883e
Database sẽ lưu chuỗi này vào cột password_hash.
Cách làm này có lợi ích lớn về bảo mật, vì:
Database không lưu mật khẩu gốc
Nếu dữ liệu bị rò rỉ, hacker không thể biết mật khẩu thật của người dùng
Đây là một nguyên tắc cơ bản trong bảo mật ứng dụng web.
3. Vấn đề trong quá trình đăng nhập
Trong chức năng đăng nhập, hệ thống nhận dữ liệu từ form login.jsp.
Form gửi hai tham số chính:
user
pass
Servlet sẽ nhận dữ liệu bằng phương thức:
String u = request.getParameter("user");
String p = request.getParameter("pass");
Tuy nhiên biến p ở đây vẫn là mật khẩu gốc do người dùng nhập, chưa được mã hóa.
Sau đó chương trình gọi DAO:
User account = dao.login(u, p);
Trong DAO, truy vấn SQL thường có dạng:
SELECT * FROM Users
WHERE email = ? AND password_hash = ?
Do database đang lưu chuỗi MD5, còn biến p lại là mật khẩu gốc, nên hai giá trị này không bao giờ giống nhau.
Ví dụ:
Giá trị	Nội dung
Mật khẩu nhập	123456
Mật khẩu trong DB	e10adc3949ba59abbe56e057f20f883e
Kết quả:
SQL không tìm thấy bản ghi
DAO trả về null
Servlet hiểu rằng đăng nhập thất bại
4. Giải pháp sửa lỗi
Để hệ thống hoạt động chính xác, cần đảm bảo quy trình xử lý mật khẩu phải giống nhau ở cả đăng ký và đăng nhập.
Cụ thể:
Khi người dùng nhập mật khẩu trong form đăng nhập
Servlet phải mã hóa mật khẩu bằng MD5
Sau đó mới gửi chuỗi hash vào DAO
Ví dụ:
String passHash = getMd5(p);
User account = dao.login(u, passHash);
Khi đó quá trình so sánh sẽ diễn ra như sau:
So sánh	Giá trị
Database	e10adc3949ba59abbe56e057f20f883e
Servlet	e10adc3949ba59abbe56e057f20f883e
Kết quả:
SQL tìm thấy bản ghi
DAO trả về User
Đăng nhập thành công
5. Quản lý phiên đăng nhập (Session)
Sau khi xác thực thành công, hệ thống cần lưu thông tin người dùng vào Session để duy trì trạng thái đăng nhập.
Ví dụ:
HttpSession session = request.getSession();
session.setAttribute("account", account);
Session sẽ cho phép hệ thống:
Nhận biết người dùng đã đăng nhập
Hiển thị thông tin cá nhân
Quản lý giỏ hàng
Thực hiện đặt hàng
Nếu không có Session, mỗi request gửi lên server sẽ bị coi như một người dùng mới.
6. Các lỗi phổ biến khác có thể xảy ra
Ngoài lỗi mã hóa mật khẩu, còn nhiều yếu tố khác có thể gây lỗi đăng nhập.
6.1 Sai tên tham số trong form
Nếu form JSP đặt tên input khác với Servlet, dữ liệu sẽ bị null.
Ví dụ:
<input name="email">
nhưng Servlet lại dùng:
request.getParameter("user")
khi đó biến u sẽ bị rỗng.
6.2 Không đồng bộ thư viện Servlet
Java Web có hai chuẩn:
Tomcat 9 trở xuống
javax.servlet
Tomcat 10 trở lên
jakarta.servlet
Nếu project dùng lẫn lộn hai chuẩn này, server có thể báo lỗi HTTP 500 hoặc không nhận diện được servlet.
7. Cải thiện bảo mật cho hệ thống
Mặc dù MD5 được sử dụng phổ biến trước đây, nhưng trong các hệ thống hiện đại, MD5 không còn được khuyến khích vì có thể bị tấn công brute-force.
Các hệ thống lớn hiện nay thường sử dụng:
BCrypt
PBKDF2
SHA-256 + Salt
Các thuật toán này giúp tăng độ khó khi hacker cố gắng giải mã mật khẩu.
Ví dụ:
Shopee, Facebook hay Google đều sử dụng hash + salt + nhiều vòng mã hóa để bảo vệ dữ liệu người dùng.
8. Kết luận
Từ quá trình phân tích trên, có thể kết luận rằng lỗi đăng nhập trong hệ thống xuất phát từ sự không đồng nhất trong quá trình mã hóa mật khẩu giữa chức năng đăng ký và đăng nhập. Khi đăng ký, mật khẩu đã được mã hóa bằng MD5 trước khi lưu vào database, nhưng khi đăng nhập lại sử dụng mật khẩu gốc để so sánh. Điều này dẫn đến việc truy vấn SQL không tìm thấy bản ghi phù hợp và hệ thống luôn trả về kết quả đăng nhập thất bại.
Sau khi bổ sung bước mã hóa mật khẩu trong LoginServlet, đồng thời kiểm tra lại tên tham số trong form JSP và cấu hình thư viện servlet, hệ thống có thể xác thực người dùng chính xác và chức năng đăng nhập sẽ hoạt động bình thường.
Ngoài ra, để nâng cao mức độ an toàn cho ứng dụng web, trong tương lai hệ thống có thể thay thế MD5 bằng các thuật toán băm hiện đại như BCrypt hoặc SHA-256, giúp bảo vệ dữ liệu người dùng tốt
