<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StoreOwner extends Model
{
    use HasFactory;

    protected $table = 'store_owners';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        'store_id',
        'ownership_percentage',
        'role',
        'permissions',
        'start_date',
        'end_date',
        'is_active',
    ];

    /**
     * The attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'ownership_percentage' => 'decimal:2',
            'permissions' => 'array',
            'start_date' => 'date',
            'end_date' => 'date',
            'is_active' => 'boolean',
        ];
    }

    /**
     * Get the user that owns the store.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the store.
     */
    public function store()
    {
        return $this->belongsTo(Stores::class, 'store_id');
    }

    /**
     * Scope for active store owners.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Check if the ownership is currently active.
     */
    public function isCurrentlyActive()
    {
        $now = now();
        return $this->is_active && 
               ($this->start_date === null || $this->start_date <= $now) &&
               ($this->end_date === null || $this->end_date >= $now);
    }
}
