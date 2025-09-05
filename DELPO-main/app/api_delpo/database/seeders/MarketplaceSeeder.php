<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Stores;
use App\Models\Category;
use App\Models\Product;
use App\Models\ProductImage;
use Illuminate\Support\Facades\Hash;

class MarketplaceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create admin user
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@campi.test',
            'password' => Hash::make('password'),
            'role_type' => 'admin',
            'is_active' => true,
            'email_verified_at' => now()
        ]);

        // Create store owner user
        $storeOwner = User::create([
            'name' => 'Store Owner',
            'email' => 'store@campi.test',
            'password' => Hash::make('password'),
            'role_type' => 'store_owner',
            'is_active' => true,
            'email_verified_at' => now()
        ]);

        // Create client user
        $client = User::create([
            'name' => 'Customer User',
            'email' => 'customer@campi.test',
            'password' => Hash::make('password'),
            'role_type' => 'client',
            'is_active' => true,
            'email_verified_at' => now()
        ]);

        // Create categories
        $electronics = Category::firstOrCreate(['name' => 'Electronics'], [
            'slug' => 'electronics',
            'description' => 'Electronic devices and gadgets',
            'is_active' => true,
            'sort_order' => 1
        ]);

        $clothing = Category::create([
            'name' => 'Clothing',
            'slug' => 'clothing',
            'description' => 'Fashion and apparel',
            'is_active' => true,
            'sort_order' => 2
        ]);

        $home = Category::create([
            'name' => 'Home & Garden',
            'slug' => 'home-garden',
            'description' => 'Home improvement and garden supplies',
            'is_active' => true,
            'sort_order' => 3
        ]);

        // Create subcategories
        $smartphones = Category::create([
            'name' => 'Smartphones',
            'slug' => 'smartphones',
            'description' => 'Mobile phones and accessories',
            'parent_id' => $electronics->id,
            'is_active' => true,
            'sort_order' => 1
        ]);

        $laptops = Category::create([
            'name' => 'Laptops',
            'slug' => 'laptops',
            'description' => 'Laptop computers and accessories',
            'parent_id' => $electronics->id,
            'is_active' => true,
            'sort_order' => 2
        ]);

        // Create store
        $store = Stores::create([
            'user_id' => $storeOwner->id,
            'name' => 'Tech World Store',
            'description' => 'Your one-stop shop for the latest technology',
            'area_name' => 'Downtown',
            'phone_number' => '+1234567890',
            'email_address' => 'contact@techworld.com',
            'category_id' => $electronics->id,
            'street_address' => '123 Tech Street, Digital City',
            'latitude_coordinate' => 40.7128,
            'longitude_coordinate' => -74.0060,
            'operational_status' => 'open',
            'is_active' => true
        ]);

        // Create products
        $products = [
            [
                'store_id' => $store->id,
                'category_id' => $smartphones->id,
                'name' => 'iPhone 15 Pro',
                'description' => 'Latest iPhone with A17 Pro chip, titanium design, and advanced camera system.',
                'price' => 999.99,
                'sku' => 'IP15PRO001',
                'stock_quantity' => 50,
                'status' => 'active',
                'is_featured' => true,
                'weight' => 0.187,
                'dimensions' => '159.9 x 76.7 x 8.25 mm'
            ],
            [
                'store_id' => $store->id,
                'category_id' => $smartphones->id,
                'name' => 'Samsung Galaxy S24',
                'description' => 'Flagship Android phone with AI features and exceptional camera quality.',
                'price' => 899.99,
                'sale_price' => 799.99,
                'sku' => 'SGS24001',
                'stock_quantity' => 30,
                'status' => 'active',
                'is_featured' => true,
                'weight' => 0.168,
                'dimensions' => '157.8 x 76.0 x 7.9 mm'
            ],
            [
                'store_id' => $store->id,
                'category_id' => $laptops->id,
                'name' => 'MacBook Pro 16"',
                'description' => 'Professional laptop with M3 Pro chip, perfect for creative professionals.',
                'price' => 2499.99,
                'sku' => 'MBP16M3001',
                'stock_quantity' => 15,
                'status' => 'active',
                'is_featured' => false,
                'weight' => 2.14,
                'dimensions' => '355.7 x 248.1 x 16.8 mm'
            ],
            [
                'store_id' => $store->id,
                'category_id' => $laptops->id,
                'name' => 'Dell XPS 13',
                'description' => 'Ultra-portable laptop with stunning InfinityEdge display.',
                'price' => 1299.99,
                'sku' => 'DXPS13001',
                'stock_quantity' => 25,
                'status' => 'active',
                'is_featured' => false,
                'weight' => 1.27,
                'dimensions' => '295.7 x 199.0 x 14.8 mm'
            ],
            [
                'store_id' => $store->id,
                'category_id' => $electronics->id,
                'name' => 'AirPods Pro 2',
                'description' => 'Premium wireless earbuds with active noise cancellation.',
                'price' => 249.99,
                'sku' => 'APP2001',
                'stock_quantity' => 100,
                'status' => 'active',
                'is_featured' => true,
                'weight' => 0.056,
                'dimensions' => '30.9 x 21.8 x 24.0 mm'
            ]
        ];

        foreach ($products as $productData) {
            $product = Product::create($productData);
            
            // Create sample product image
            ProductImage::create([
                'product_id' => $product->id,
                'image_url' => 'https://via.placeholder.com/400x400?text=' . urlencode($product->name),
                'alt_text' => $product->name . ' image',
                'sort_order' => 1,
                'is_primary' => true
            ]);
        }

        $this->command->info('Marketplace sample data created successfully!');
        $this->command->info('Users created:');
        $this->command->info('- Admin: admin@campi.test (password: password)');
        $this->command->info('- Store Owner: store@campi.test (password: password)');
        $this->command->info('- Customer: customer@campi.test (password: password)');
        $this->command->info('- Store: Tech World Store');
        $this->command->info('- Products: 5 sample products created');
    }
}
