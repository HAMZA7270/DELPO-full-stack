<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use App\Models\Product;
use App\Models\Stores;

class TestDataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create a test user first
        $user = \App\Models\User::firstOrCreate(
            ['email' => 'test@user.com'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password'),
            ]
        );

        // Create test categories
        $categories = [
            [
                'name' => 'إلكترونيات',
                'slug' => 'electronics',
                'description' => 'أجهزة إلكترونية وتقنية',
                'icon_url' => null,
                'color_code' => '#2196F3',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'ملابس',
                'slug' => 'clothing',
                'description' => 'ملابس رجالية ونسائية',
                'icon_url' => null,
                'color_code' => '#E91E63',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'name' => 'طعام ومشروبات',
                'slug' => 'food-beverages',
                'description' => 'مأكولات ومشروبات متنوعة',
                'icon_url' => null,
                'color_code' => '#FF9800',
                'sort_order' => 3,
                'is_active' => true,
            ],
        ];

        $createdCategories = [];
        foreach ($categories as $categoryData) {
            $createdCategories[] = Category::firstOrCreate(['slug' => $categoryData['slug']], $categoryData);
        }

        // Create test store
        $store = Stores::firstOrCreate(
            ['email_address' => 'test@store.com'],
            [
                'name' => 'متجر تجريبي',
                'description' => 'متجر للاختبار',
                'street_address' => 'الرياض، المملكة العربية السعودية',
                'phone_number' => '+966501234567',
                'operational_status' => 'open',
                'is_active' => true,
                'user_id' => $user->id,
                'category_id' => $createdCategories[0]->id,
                'area_name' => 'الرياض',
            ]
        );

        // Create test products
        $products = [
            [
                'name' => 'هاتف ذكي',
                'description' => 'هاتف ذكي حديث بمواصفات عالية',
                'price' => 1299.99,
                'stock_quantity' => 50,
                'sku' => 'PHONE001',
                'weight' => 0.2,
                'dimensions' => '15x7x0.8 cm',
                'status' => 'active',
                'category_id' => $createdCategories[0]->id, // Electronics
                'store_id' => $store->id,
            ],
            [
                'name' => 'قميص قطني',
                'description' => 'قميص قطني مريح للاستخدام اليومي',
                'price' => 89.99,
                'stock_quantity' => 25,
                'sku' => 'SHIRT001',
                'weight' => 0.3,
                'dimensions' => 'L',
                'status' => 'active',
                'category_id' => $createdCategories[1]->id, // Clothing
                'store_id' => $store->id,
            ],
            [
                'name' => 'عصير طبيعي',
                'description' => 'عصير برتقال طبيعي 100%',
                'price' => 12.50,
                'stock_quantity' => 100,
                'sku' => 'JUICE001',
                'weight' => 1.0,
                'dimensions' => '1 لتر',
                'status' => 'active',
                'category_id' => $createdCategories[2]->id, // Food & Beverages
                'store_id' => $store->id,
            ],
        ];

        foreach ($products as $productData) {
            Product::firstOrCreate(['sku' => $productData['sku']], $productData);
        }
    }
}
