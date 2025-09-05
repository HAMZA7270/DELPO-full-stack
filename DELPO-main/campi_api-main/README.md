# campi_api
erDiagram
    %% إدارة المستخدمين - User Management
    User {
        int id PK "المعرف الفريد"
        string name "اسم المستخدم الكامل"
        string email UK "البريد الإلكتروني الفريد"
        string role_type "نوع المستخدم: عميل، صاحب متجر، مزود خدمة، مدير"
        bool is_active "حالة نشاط الحساب"
        timestamp email_verified_at "تاريخ تأكيد البريد الإلكتروني"
        string password "كلمة المرور المشفرة"
        string remember_token "رمز تذكر تسجيل الدخول"
        timestamp created_at "تاريخ إنشاء الحساب"
        timestamp updated_at "تاريخ آخر تحديث"
    }

    Address {
        int id PK "المعرف الفريد للعنوان"
        int user_id FK "معرف المستخدم صاحب العنوان"
        string type "نوع العنوان: منزل، عمل، فواتير، شحن"
        string label "تسمية العنوان المخصصة"
        string address_line_1 "السطر الأول من العنوان"
        string address_line_2 "السطر الثاني من العنوان"
        string city "المدينة"
        string state "الولاية أو المنطقة"
        string postal_code "الرمز البريدي"
        string country "البلد"
        decimal latitude "خط العرض للموقع الجغرافي"
        decimal longitude "خط الطول للموقع الجغرافي"
        bool is_default "هل هذا العنوان الافتراضي"
        bool is_active "حالة نشاط العنوان"
        timestamp created_at "تاريخ إضافة العنوان"
        timestamp updated_at "تاريخ آخر تحديث للعنوان"
    }

    %% إدارة المتاجر - Store Management
    Store {
        int id PK "المعرف الفريد للمتجر"
        int user_id FK "معرف صاحب المتجر"
        string name "اسم المتجر التجاري"
        text description "وصف المتجر ونشاطه"
        string logo "رابط شعار المتجر"
        string banner "رابط صورة غلاف المتجر"
        timestamp created_at "تاريخ إنشاء المتجر"
        timestamp updated_at "تاريخ آخر تحديث للمتجر"
    }

    %% إدارة المنتجات - Product Management
    Category {
        int id PK "المعرف الفريد للفئة"
        string name "اسم الفئة"
        text description "وصف الفئة"
        string image "صورة الفئة"
        int parent_id FK "معرف الفئة الأب (للفئات الفرعية)"
        bool is_active "حالة نشاط الفئة"
        int sort_order "ترتيب عرض الفئة"
        timestamp created_at "تاريخ إنشاء الفئة"
        timestamp updated_at "تاريخ آخر تحديث للفئة"
    }

    Product {
        int id PK "المعرف الفريد للمنتج"
        string name "اسم المنتج"
        text description "وصف تفصيلي للمنتج"
        decimal price "سعر المنتج"
        int stock_quantity "كمية المخزون المتاحة"
        string sku UK "رمز المنتج الفريد"
        decimal weight "وزن المنتج"
        string dimensions "أبعاد المنتج"
        bool is_active "حالة نشاط المنتج"
        int category_id FK "معرف فئة المنتج"
        int store_id FK "معرف المتجر الذي يحتوي على المنتج"
        timestamp created_at "تاريخ إضافة المنتج"
        timestamp updated_at "تاريخ آخر تحديث للمنتج"
    }

    ProductImage {
        int id PK "المعرف الفريد للصورة"
        int product_id FK "معرف المنتج الذي تخص الصورة"
        string image_path "مسار ملف الصورة"
        string alt_text "نص بديل للصورة"
        int sort_order "ترتيب عرض الصورة"
        bool is_primary "هل هذه الصورة الرئيسية"
        timestamp created_at "تاريخ إضافة الصورة"
        timestamp updated_at "تاريخ آخر تحديث للصورة"
    }

    %% إدارة سلة التسوق - Cart Management
    Cart {
        int id PK "المعرف الفريد للسلة"
        int user_id FK "معرف المستخدم صاحب السلة"
        timestamp created_at "تاريخ إنشاء السلة"
        timestamp updated_at "تاريخ آخر تحديث للسلة"
    }

    CartItem {
        int id PK "المعرف الفريد لعنصر السلة"
        int cart_id FK "معرف السلة"
        int product_id FK "معرف المنتج"
        int quantity "الكمية المطلوبة"
        decimal price "سعر المنتج وقت الإضافة للسلة"
        timestamp created_at "تاريخ إضافة العنصر للسلة"
        timestamp updated_at "تاريخ آخر تحديث للعنصر"
    }

    %% إدارة الطلبات - Order Management
    Order {
        int id PK "المعرف الفريد للطلب"
        string order_number UK "رقم الطلب الفريد"
        int user_id FK "معرف العميل الذي قام بالطلب"
        string status "حالة الطلب: معلق، مؤكد، قيد التحضير، مشحون، مسلم، ملغى"
        decimal total_amount "المبلغ الإجمالي للطلب"
        decimal shipping_cost "تكلفة الشحن"
        decimal tax_amount "مبلغ الضريبة"
        decimal discount_amount "مبلغ الخصم"
        string payment_method "طريقة الدفع المستخدمة"
        string payment_status "حالة الدفع: معلق، مدفوع، فشل، مُسترد"
        int delivery_address_id FK "معرف عنوان التوصيل"
        timestamp delivery_date "تاريخ التوصيل المتوقع"
        text notes "ملاحظات خاصة بالطلب"
        timestamp created_at "تاريخ إنشاء الطلب"
        timestamp updated_at "تاريخ آخر تحديث للطلب"
    }

    OrderItem {
        int id PK "المعرف الفريد لعنصر الطلب"
        int order_id FK "معرف الطلب"
        int product_id FK "معرف المنتج"
        int quantity "الكمية المطلوبة"
        decimal price "سعر المنتج وقت الطلب"
        decimal total "إجمالي سعر هذا العنصر"
        timestamp created_at "تاريخ إضافة العنصر للطلب"
        timestamp updated_at "تاريخ آخر تحديث للعنصر"
    }

    %% إدارة الخدمات - Service Management
    ServiceProvider {
        int id PK "المعرف الفريد لمزود الخدمة"
        int user_id FK "معرف المستخدم المرتبط بمزود الخدمة"
        string business_name "اسم العمل أو الشركة"
        int service_category_id FK "معرف فئة الخدمة الرئيسية"
        json skills "المهارات والخبرات"
        int experience_years "سنوات الخبرة في المجال"
        decimal hourly_rate "السعر بالساعة"
        text description "وصف تفصيلي عن مزود الخدمة"
        json portfolio_images "صور أعمال سابقة ومعرض الأعمال"
        json certifications "الشهادات والمؤهلات المهنية"
        json availability_schedule "جدول أوقات التوفر والعمل"
        decimal service_radius "نطاق تقديم الخدمة بالكيلومتر"
        decimal latitude "خط العرض لموقع مزود الخدمة"
        decimal longitude "خط الطول لموقع مزود الخدمة"
        text address "عنوان مزود الخدمة"
        string phone "رقم الهاتف للتواصل"
        string email "البريد الإلكتروني للتواصل"
        string website "الموقع الإلكتروني الشخصي"
        json social_media_links "روابط وسائل التواصل الاجتماعي"
        decimal rating "متوسط التقييم العام"
        int total_reviews "إجمالي عدد التقييمات"
        int total_jobs_completed "إجمالي عدد الأعمال المكتملة"
        bool is_verified "هل تم التحقق من هوية مزود الخدمة"
        bool is_active "حالة نشاط الحساب"
        bool is_available "توفر مزود الخدمة لقبول حجوزات جديدة"
        json verification_documents "وثائق التحقق من الهوية"
        timestamp created_at "تاريخ إنشاء الملف الشخصي"
        timestamp updated_at "تاريخ آخر تحديث للملف الشخصي"
    }

    Service {
        int id PK "المعرف الفريد للخدمة"
        int service_provider_id FK "معرف مزود الخدمة"
        string name "اسم الخدمة"
        text description "وصف تفصيلي للخدمة"
        int category_id FK "معرف فئة الخدمة"
        string price_type "نوع التسعير: ثابت، بالساعة، مخصص"
        decimal base_price "السعر الأساسي الثابت للخدمة"
        decimal hourly_rate "السعر بالساعة"
        decimal duration_hours "مدة تقديم الخدمة بالساعات"
        json requirements "المتطلبات والشروط اللازمة للخدمة"
        json service_images "مجموعة صور للخدمة"
        json availability_schedule "جدول أوقات توفر الخدمة"
        string service_location_type "نوع موقع تقديم الخدمة: منزل، مكتب، عن بُعد"
        decimal max_distance "أقصى مسافة لتقديم الخدمة بالكيلومتر"
        int preparation_time "وقت التحضير المطلوب بالدقائق"
        text cancellation_policy "سياسة إلغاء الخدمة"
        text terms_conditions "الشروط والأحكام الخاصة بالخدمة"
        bool is_active "حالة نشاط الخدمة"
        bool is_featured "هل الخدمة مميزة"
        int sort_order "ترتيب عرض الخدمة"
        string seo_title "عنوان تحسين محركات البحث"
        text seo_description "وصف تحسين محركات البحث"
        json meta_tags "الكلمات المفتاحية والعلامات الوصفية"
        timestamp created_at "تاريخ إنشاء الخدمة"
        timestamp updated_at "تاريخ آخر تحديث للخدمة"
    }

    ServiceBooking {
        int id PK "المعرف الفريد للحجز"
        int client_id FK "معرف العميل الذي حجز الخدمة"
        int service_provider_id FK "معرف مزود الخدمة"
        int service_id FK "معرف الخدمة المحجوزة"
        date booking_date "تاريخ الحجز"
        datetime start_time "وقت بداية تقديم الخدمة"
        datetime end_time "وقت انتهاء تقديم الخدمة"
        string status "حالة الحجز: معلق، مؤكد، قيد التنفيذ، مكتمل، ملغى"
        decimal total_price "السعر الإجمالي للخدمة"
        text special_requirements "المتطلبات الخاصة للعميل"
        string location_type "نوع موقع تقديم الخدمة"
        text service_address "عنوان تقديم الخدمة"
        decimal latitude "خط العرض لموقع الخدمة"
        decimal longitude "خط الطول لموقع الخدمة"
        int estimated_duration "المدة المقدرة للخدمة بالدقائق"
        int actual_duration "المدة الفعلية للخدمة بالدقائق"
        text cancellation_reason "سبب إلغاء الحجز"
        text notes "ملاحظات إضافية على الحجز"
        string payment_status "حالة الدفع"
        string payment_method "طريقة الدفع المستخدمة"
        decimal commission_rate "نسبة العمولة للمنصة"
        decimal commission_amount "مبلغ العمولة للمنصة"
        decimal provider_earnings "أرباح مزود الخدمة"
        string booking_reference "رقم مرجعي فريد للحجز"
        timestamp completed_at "تاريخ إكمال الخدمة"
        timestamp cancelled_at "تاريخ إلغاء الحجز"
        timestamp created_at "تاريخ إنشاء الحجز"
        timestamp updated_at "تاريخ آخر تحديث للحجز"
    }

    %% قائمة الأمنيات - Wishlist
    Wishlist {
        int id PK "المعرف الفريد لعنصر قائمة الأمنيات"
        int user_id FK "معرف المستخدم صاحب قائمة الأمنيات"
        int product_id FK "معرف المنتج المُضاف لقائمة الأمنيات"
        timestamp created_at "تاريخ إضافة المنتج لقائمة الأمنيات"
        timestamp updated_at "تاريخ آخر تحديث"
    }

    %% التقييمات والمراجعات - Reviews
    Review {
        int id PK "المعرف الفريد للتقييم"
        int reviewable_id "معرف العنصر المُقيم (منتج أو خدمة)"
        string reviewable_type "نوع العنصر المُقيم"
        int user_id FK "معرف المستخدم الذي كتب التقييم"
        int rating "التقييم من 1 إلى 5"
        text comment "تعليق وملاحظات التقييم"
        json images "صور مرفقة مع التقييم"
        bool is_verified "هل التقييم مُتحقق منه"
        timestamp created_at "تاريخ كتابة التقييم"
        timestamp updated_at "تاريخ آخر تحديث للتقييم"
    }

    %% العلاقات - Relationships
    User ||--o{ Address : "يملك عناوين متعددة"
    User ||--o{ Store : "يملك متاجر"
    User ||--o| ServiceProvider : "له ملف مزود خدمة"
    User ||--o{ Order : "يضع طلبات"
    User ||--o| Cart : "له سلة تسوق"
    User ||--o{ Wishlist : "له قائمة أمنيات"
    User ||--o{ Review : "يكتب تقييمات"
    User ||--o{ ServiceBooking : "يحجز خدمات كعميل"

    Store ||--o{ Product : "يحتوي على منتجات"
    Store }o--|| User : "ينتمي لمستخدم"

    Category ||--o{ Product : "تصنف المنتجات"
    Category ||--o{ Category : "تحتوي على فئات فرعية"
    Category ||--o{ Service : "تصنف الخدمات"
    Category ||--o{ ServiceProvider : "الفئة الرئيسية لمزود الخدمة"

    Product ||--o{ ProductImage : "له صور متعددة"
    Product ||--o{ CartItem : "في سلال التسوق"
    Product ||--o{ OrderItem : "في الطلبات"
    Product ||--o{ Wishlist : "في قوائم الأمنيات"
    Product }o--|| Category : "ينتمي لفئة"
    Product }o--|| Store : "ينتمي لمتجر"

    Cart ||--o{ CartItem : "يحتوي على عناصر"
    Cart }o--|| User : "ينتمي لمستخدم"

    CartItem }o--|| Product : "يشير لمنتج"
    CartItem }o--|| Cart : "ينتمي لسلة"

    Order ||--o{ OrderItem : "يحتوي على عناصر"
    Order }o--|| User : "ينتمي لمستخدم"
    Order }o--|| Address : "يُسلم لعنوان"

    OrderItem }o--|| Product : "يشير لمنتج"
    OrderItem }o--|| Order : "ينتمي لطلب"

    ServiceProvider ||--o{ Service : "يقدم خدمات"
    ServiceProvider ||--o{ ServiceBooking : "يستقبل حجوزات"
    ServiceProvider }o--|| User : "ينتمي لمستخدم"
    ServiceProvider }o--|| Category : "الفئة الرئيسية"

    Service ||--o{ ServiceBooking : "يُحجز"
    Service }o--|| ServiceProvider : "ينتمي لمزود خدمة"
    Service }o--|| Category : "ينتمي لفئة"

    ServiceBooking }o--|| User : "العميل"
    ServiceBooking }o--|| ServiceProvider : "مزود الخدمة"
    ServiceBooking }o--|| Service : "للخدمة"

    Wishlist }o--|| User : "ينتمي لمستخدم"
    Wishlist }o--|| Product : "يشير لمنتج"

    Review }o--|| User : "كُتب بواسطة مستخدم"