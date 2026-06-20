using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using SmartBook.API.Models;
using SmartBook.API.Models.Enums;

namespace SmartBook.API.Data;

public partial class SmartBookDbContext : DbContext
{
    public SmartBookDbContext()
    {
    }

    public SmartBookDbContext(DbContextOptions<SmartBookDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }
    public virtual DbSet<CompanyProfile> CompanyProfiles { get; set; }
    public virtual DbSet<Contact> Contacts { get; set; }
    public virtual DbSet<Invoice> Invoices { get; set; }
    public virtual DbSet<InvoiceDetail> InvoiceDetails { get; set; }
    public virtual DbSet<JournalDetail> JournalDetails { get; set; }
    public virtual DbSet<JournalEntry> JournalEntries { get; set; }
    public virtual DbSet<Role> Roles { get; set; }
    public virtual DbSet<User> Users { get; set; }
    public virtual DbSet<Voucher> Vouchers { get; set; }
    public virtual DbSet<Product> Products { get; set; }
    public virtual DbSet<ProductUnit> ProductUnits { get; set; }
    public virtual DbSet<AccountMapping> AccountMappings { get; set; }
 public DbSet<InventoryLog> InventoryLogs { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Server=HP\\SQLEXPRESS02;Database=SmartBookDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // ====== Account Configuration ======
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.AccountId);

            entity.HasIndex(e => e.AccountCode).IsUnique();

            entity.Property(e => e.AccountId).HasColumnName("AccountID");
            entity.Property(e => e.AccountCode).HasMaxLength(20);
            entity.Property(e => e.AccountNameAr).HasMaxLength(200);
            entity.Property(e => e.AccountNameEn).HasMaxLength(200);

            entity.Property(e => e.AccountType)
                  .HasConversion<int>()
                  .IsRequired();

            entity.Property(e => e.IsMain).HasDefaultValue(false);
            entity.Property(e => e.Level).HasDefaultValue(1);
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.Property(e => e.CreatedAt)
                  .HasDefaultValueSql("(getdate())")
                  .HasColumnType("datetime");

            entity.Property(e => e.ParentAccountId).HasColumnName("ParentAccountID");

            entity.HasOne(d => d.ParentAccount)
                .WithMany(p => p.InverseParentAccount)
                .HasForeignKey(d => d.ParentAccountId);
        });

        // ====== CompanyProfile ======
        modelBuilder.Entity<CompanyProfile>(entity =>
        {
            entity.HasKey(e => e.Id);

            entity.ToTable("CompanyProfile");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Currency)
                .HasMaxLength(50)
                .HasDefaultValueSql("(N'ر.س')");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.NameAr).HasMaxLength(250);
            entity.Property(e => e.NameEn).HasMaxLength(250);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.TaxNumber).HasMaxLength(15);
        });

        // ====== Contacts ======
        modelBuilder.Entity<Contact>(entity =>
        {
            entity.HasKey(e => e.ContactId);

            entity.Property(e => e.ContactId).HasColumnName("ContactID");
            entity.Property(e => e.AccountId).HasColumnName("AccountID");
            entity.Property(e => e.ContactType).HasMaxLength(20);
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Name).HasMaxLength(200);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.TaxNumber).HasMaxLength(15);

            entity.HasOne(d => d.Account)
                .WithMany(p => p.Contacts)
                .HasForeignKey(d => d.AccountId);
        });

        // ====== Invoice ======
        modelBuilder.Entity<Invoice>(entity =>
        {
            entity.HasKey(e => e.InvoiceId);

            entity.HasIndex(e => e.InvoiceNumber).IsUnique();

            entity.Property(e => e.InvoiceId).HasColumnName("InvoiceID");
            entity.Property(e => e.ContactId).HasColumnName("ContactID");
            entity.Property(e => e.InvoiceDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.InvoiceNumber).HasMaxLength(50);
            entity.Property(e => e.PaymentType).HasMaxLength(20);
            entity.Property(e => e.SubTotal).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TaxAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Contact)
                .WithMany(p => p.Invoices)
                .HasForeignKey(d => d.ContactId);

            entity.HasOne(d => d.User)
                .WithMany(p => p.Invoices)
                .HasForeignKey(d => d.UserId);
            entity.HasOne(d => d.Entry)
          .WithMany() // أو يمكن عمل علاقة One-to-One
          .HasForeignKey(d => d.EntryId)
          .OnDelete(DeleteBehavior.SetNull);
        });

        // ====== Invoice Details ======
        modelBuilder.Entity<InvoiceDetail>(entity =>
        {
            entity.HasKey(e => e.DetailId);

            entity.Property(e => e.DetailId).HasColumnName("DetailID");
            entity.Property(e => e.InvoiceId).HasColumnName("InvoiceID");
            entity.Property(e => e.ItemName).HasMaxLength(200);
            entity.Property(e => e.Quantity).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TaxAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TotalLine).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Invoice)
                .WithMany(p => p.InvoiceDetails)
                .HasForeignKey(d => d.InvoiceId);
        });

        // ====== Journal Detail ======
        modelBuilder.Entity<JournalDetail>(entity =>
        {
            entity.HasKey(e => e.DetailId);

            entity.Property(e => e.DetailId).HasColumnName("DetailID");
            entity.Property(e => e.AccountId).HasColumnName("AccountID");
            entity.Property(e => e.Credit)
                .HasDefaultValueSql("((0))")
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Debit)
                .HasDefaultValueSql("((0))")
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.EntryId).HasColumnName("EntryID");

            entity.HasOne(d => d.Account)
                .WithMany(p => p.JournalDetails)
                .HasForeignKey(d => d.AccountId);

            entity.HasOne(d => d.Entry)
                .WithMany(p => p.JournalDetails)
                .HasForeignKey(d => d.EntryId);
        });

        // ====== Journal Entry ======
        modelBuilder.Entity<JournalEntry>(entity =>
        {
            entity.HasKey(e => e.EntryId);

            entity.Property(e => e.EntryId).HasColumnName("EntryID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.EntryDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.ReferenceNo).HasMaxLength(50);
        });

        // ====== Role ======
        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId);

            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.RoleName).HasMaxLength(50);
        });

        // ====== User ======
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId);

            entity.HasIndex(e => e.Username).IsUnique();

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.FullName).HasMaxLength(150);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.LastLogin).HasColumnType("datetime");
            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.Username).HasMaxLength(50);

            entity.HasOne(d => d.Role)
                .WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId);
        });
        // ====== Voucher ======
        modelBuilder.Entity<Voucher>(entity =>
        {
            entity.HasKey(e => e.VoucherId);

            entity.Property(e => e.VoucherId).HasColumnName("VoucherID");
            entity.Property(e => e.VoucherNumber).HasMaxLength(50);
            entity.Property(e => e.VoucherType).HasMaxLength(20);
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.VoucherDate)
                  .HasDefaultValueSql("(getdate())")
                  .HasColumnType("datetime");
            entity.Property(e => e.CreatedAt)
                  .HasDefaultValueSql("(getdate())")
                  .HasColumnType("datetime");

            entity.Property(e => e.CreatedBy).HasColumnName("CreatedBy");

            // الربط الجديد: السند مرتبط بقيد محاسبي
            entity.Property(e => e.EntryId).HasColumnName("EntryID");
            entity.HasOne(d => d.Entry)
                  .WithMany() // إذا لم يكن هناك Navigation Property في JournalEntry
                  .HasForeignKey(d => d.EntryId)
                  .OnDelete(DeleteBehavior.SetNull);

            entity.HasOne(d => d.CreatedByNavigation)
                  .WithMany(p => p.Vouchers)
                  .HasForeignKey(d => d.CreatedBy);

            entity.Property(e => e.FromAccountId).HasColumnName("FromAccountId");
            entity.Property(e => e.ToAccountId).HasColumnName("ToAccountId");

            entity.HasOne(d => d.FromAccount)
                  .WithMany()
                  .HasForeignKey(d => d.FromAccountId);

            entity.HasOne(d => d.ToAccount)
                  .WithMany()
                  .HasForeignKey(d => d.ToAccountId);
        });

        // ====== Account Mapping ======
        modelBuilder.Entity<AccountMapping>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.MovementType).IsUnique(); // قيد يمنع تكرار نوع الحركة
            entity.Property(e => e.MovementType).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Description).HasMaxLength(200);

            entity.HasOne(d => d.Account)
                  .WithMany()
                  .HasForeignKey(d => d.AccountId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // ====== product ======


        // 1. إعدادات جدول المنتجات (الأب)
        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId);
            entity.Property(e => e.ProductNameAr).IsRequired().HasMaxLength(200);

            // تحديد الدقة لكمية المخزن (لأنه قد يكون هناك كسور مثل 1.5 كيلو)
            entity.Property(e => e.TotalStockQuantity).HasPrecision(18, 3);
        });

        // 2. إعدادات جدول الوحدات (الابن)
        modelBuilder.Entity<ProductUnit>(entity =>
        {
            entity.HasKey(e => e.UnitId);
            entity.Property(e => e.UnitName).IsRequired().HasMaxLength(50);

            // ضروري جداً تحديد الدقة لحقول الـ decimal لتجنب تحذيرات EF Core
            entity.Property(e => e.SalePrice).HasPrecision(18, 2);
            entity.Property(e => e.PurchasePrice).HasPrecision(18, 2);
            entity.Property(e => e.ConversionFactor).HasPrecision(18, 3);

            // إعداد العلاقة (One-to-Many)
            // المنتج الواحد له وحدات كثيرة، والوحدة تتبع منتج واحد
            entity.HasOne(d => d.Product)
                  .WithMany(p => p.ProductUnits)
                  .HasForeignKey(d => d.ProductId)
                  .OnDelete(DeleteBehavior.Cascade); // إذا حُذف المنتج تُحذف وحداته تلقائياً
        });

        // كود الـ Role اللي أنت أرسلته يظل كما هو تحتهم


        // ====== Account Mapping ======
        modelBuilder.Entity<AccountMapping>(entity =>
        {
            // تعريف المفتاح الأساسي
            entity.HasKey(e => e.Id);

            // جعل نوع الحركة مفهرساً للسرعة (لأننا سنبحث به كثيراً عند إنشاء الفواتير)
            entity.HasIndex(e => e.MovementType);

            // قيود الخصائص
            entity.Property(e => e.MovementType)
                .IsRequired()
                .HasMaxLength(50); // نوع الحركة (مثال: 'Sales', 'Purchase')

            entity.Property(e => e.Description)
                .HasMaxLength(200);

            // تعريف العلاقة مع جدول الحسابات
            // كل "إعداد" يرتبط بحساب واحد، والحساب الواحد قد يكون له عدة إعدادات (ربط)
            entity.HasOne(d => d.Account)
                .WithMany() // إذا لم يكن هناك Navigation Property في كلاس Account
                .HasForeignKey(d => d.AccountId)
                .OnDelete(DeleteBehavior.Restrict); // منع حذف الحساب إذا كان مربوطاً بإعداد حركة
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}