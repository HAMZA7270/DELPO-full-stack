<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use App\Models\Product;
use App\Models\Stores;
use App\Models\User;

class ExpandedDataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create additional test users for store owners
        $users = [];
        for ($i = 2; $i <= 10; $i++) {
            $users[] = User::firstOrCreate(
                ['email' => "user{$i}@test.com"],
                [
                    'name' => "مستخدم تجريبي {$i}",
                    'password' => bcrypt('password'),
                ]
            );
        }

        // Get existing categories
        $categories = Category::all();

        // Create more stores for each category
        $storeData = [
            // Electronics stores
            [
                'name' => 'متجر الإلكترونيات المتقدم',
                'description' => 'أحدث الأجهزة الإلكترونية والتقنية',
                'street_address' => 'شارع الملك فهد، الرياض',
                'phone_number' => '+966502234567',
                'email_address' => 'advanced@electronics.com',
                'area_name' => 'الرياض',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 1,
                'user_id' => $users[0]->id ?? 2,
            ],
            [
                'name' => 'عالم التكنولوجيا',
                'description' => 'كل ما تحتاجه من تقنية حديثة',
                'street_address' => 'حي العليا، الرياض',
                'phone_number' => '+966503345678',
                'email_address' => 'tech@world.com',
                'area_name' => 'الرياض',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 1,
                'user_id' => $users[1]->id ?? 3,
            ],
            // Clothing stores
            [
                'name' => 'أزياء العصر',
                'description' => 'أحدث صيحات الموضة للرجال والنساء',
                'street_address' => 'شارع التحلية، جدة',
                'phone_number' => '+966504456789',
                'email_address' => 'fashion@modern.com',
                'area_name' => 'جدة',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 2,
                'user_id' => $users[2]->id ?? 4,
            ],
            [
                'name' => 'متجر الأناقة',
                'description' => 'ملابس راقية بأسعار مناسبة',
                'street_address' => 'شارع الأمير محمد، الدمام',
                'phone_number' => '+966505567890',
                'email_address' => 'elegant@store.com',
                'area_name' => 'الدمام',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 2,
                'user_id' => $users[3]->id ?? 5,
            ],
            // Food & Beverages stores
            [
                'name' => 'سوق الخضار الطازجة',
                'description' => 'خضار وفواكه طازجة يومياً',
                'street_address' => 'سوق الخضار المركزي، الرياض',
                'phone_number' => '+966506678901',
                'email_address' => 'fresh@vegetables.com',
                'area_name' => 'الرياض',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 3,
                'user_id' => $users[4]->id ?? 6,
            ],
            [
                'name' => 'مشروبات الصحة',
                'description' => 'عصائر طبيعية ومشروبات صحية',
                'street_address' => 'شارع الصحة، مكة',
                'phone_number' => '+966507789012',
                'email_address' => 'healthy@drinks.com',
                'area_name' => 'مكة',
                'operational_status' => 'open',
                'is_active' => true,
                'category_id' => 3,
                'user_id' => $users[5]->id ?? 7,
            ],
        ];

        $createdStores = [];
        foreach ($storeData as $store) {
            $createdStores[] = Stores::firstOrCreate(
                ['email_address' => $store['email_address']],
                $store
            );
        }

        // Create more products for each store
        $productData = [
            // Electronics products
            [
                'name' => 'لابتوب جيمنج',
                'description' => 'لابتوب عالي الأداء للألعاب والبرمجة',
                'price' => 4999.99,
                'stock_quantity' => 15,
                'sku' => 'LAPTOP001',
                'weight' => 2.5,
                'dimensions' => '35x25x2 cm',
                'status' => 'active',
                'category_id' => 1,
                'store_id' => $createdStores[0]->id,
            ],
            [
                'name' => 'سماعات بلوتوث',
                'description' => 'سماعات لاسلكية عالية الجودة',
                'price' => 299.99,
                'stock_quantity' => 50,
                'sku' => 'HEADPHONES001',
                'weight' => 0.3,
                'dimensions' => '18x16x8 cm',
                'status' => 'active',
                'category_id' => 1,
                'store_id' => $createdStores[1]->id,
            ],
            [
                'name' => 'كاميرا رقمية',
                'description' => 'كاميرا عالية الدقة للتصوير الاحترافي',
                'price' => 2299.99,
                'stock_quantity' => 8,
                'sku' => 'CAMERA001',
                'weight' => 1.2,
                'dimensions' => '15x12x10 cm',
                'status' => 'active',
                'category_id' => 1,
                'store_id' => $createdStores[0]->id,
            ],
            // Clothing products
            [
                'name' => 'فستان صيفي',
                'description' => 'فستان قطني مريح للصيف',
                'price' => 159.99,
                'stock_quantity' => 30,
                'sku' => 'DRESS001',
                'weight' => 0.4,
                'dimensions' => 'M',
                'status' => 'active',
                'category_id' => 2,
                'store_id' => $createdStores[2]->id,
            ],
            [
                'name' => 'بنطلون جينز',
                'description' => 'بنطلون جينز كلاسيكي عالي الجودة',
                'price' => 199.99,
                'stock_quantity' => 40,
                'sku' => 'JEANS001',
                'weight' => 0.8,
                'dimensions' => 'L',
                'status' => 'active',
                'category_id' => 2,
                'store_id' => $createdStores[3]->id,
            ],
            [
                'name' => 'حقيبة يد نسائية',
                'description' => 'حقيبة أنيقة للاستخدام اليومي',
                'price' => 259.99,
                'stock_quantity' => 20,
                'sku' => 'BAG001',
                'weight' => 0.6,
                'dimensions' => '30x20x15 cm',
                'status' => 'active',
                'category_id' => 2,
                'store_id' => $createdStores[2]->id,
            ],
            // Food & Beverages products
            [
                'name' => 'طماطم عضوية',
                'description' => 'طماطم طازجة مزروعة بطريقة عضوية',
                'price' => 8.50,
                'stock_quantity' => 200,
                'sku' => 'TOMATO001',
                'weight' => 1.0,
                'dimensions' => '1 كيلو',
                'status' => 'active',
                'category_id' => 3,
                'store_id' => $createdStores[4]->id,
            ],
            [
                'name' => 'عسل طبيعي',
                'description' => 'عسل نقي من المراعي السعودية',
                'price' => 85.00,
                'stock_quantity' => 50,
                'sku' => 'HONEY001',
                'weight' => 0.5,
                'dimensions' => '500 جرام',
                'status' => 'active',
                'category_id' => 3,
                'store_id' => $createdStores[5]->id,
            ],
            [
                'name' => 'تمر المدينة',
                'description' => 'تمر عجوة من المدينة المنورة',
                'price' => 45.00,
                'stock_quantity' => 75,
                'sku' => 'DATES001',
                'weight' => 0.5,
                'dimensions' => '500 جرام',
                'status' => 'active',
                'category_id' => 3,
                'store_id' => $createdStores[4]->id,
            ],
            [
                'name' => 'زيت زيتون بكر',
                'description' => 'زيت زيتون بكر ممتاز عالي الجودة',
                'price' => 65.00,
                'stock_quantity' => 40,
                'sku' => 'OLIVE_OIL001',
                'weight' => 0.75,
                'dimensions' => '750 مل',
                'status' => 'active',
                'category_id' => 3,
                'store_id' => $createdStores[5]->id,
            ],
        ];

        foreach ($productData as $product) {
            Product::firstOrCreate(['sku' => $product['sku']], $product);
        }

        $this->command->info('تم إضافة المزيد من البيانات التجريبية بنجاح!');
        $this->command->info('المتاجر: ' . Stores::count());
        $this->command->info('المنتجات: ' . Product::count());
        $this->command->info('الفئات: ' . Category::count());
    }
}
