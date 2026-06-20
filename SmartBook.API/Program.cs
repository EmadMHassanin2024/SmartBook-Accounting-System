using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SmartBook.API.Data;
using SmartBook.API.Repositories;
using SmartBook.API.Services;
using System.Text;

namespace SmartBook.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // 1. إعداد السيرفر للاستماع على أي IP (مهم جداً للمحاكي والويب ومتصفح كروم)
            builder.WebHost.ConfigureKestrel(options =>
            {
                options.ListenAnyIP(5069); // HTTP
                options.ListenAnyIP(7104, listenOptions => listenOptions.UseHttps()); // HTTPS
            });

            // 2. تسجيل خدمة قاعدة البيانات المعتمدة لـ SmartBookDB
            builder.Services.AddDbContext<SmartBookDbContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

            // 3. إضافة خدمات الـ CORS مع تهيئتها الكاملة لمتصفحات الويب
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowAll", policy =>
                {
                    policy.AllowAnyOrigin()
                          .AllowAnyMethod()
                          .AllowAnyHeader();
                });
            });

            // 4. تسجيل الـ Controllers ومعالجة الحلقات المفرغة في الـ JSON (منع الـ Cycles المتعارضة)
            builder.Services.AddControllers().AddJsonOptions(options =>
            {
                // يتجاهل التكرار الدائري أثناء تحويل البيانات لـ JSON
                options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
            });

            // إعداد أداة تتبع الـ APIs (Swagger)
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // 5. تسجيل الـ Repositories الخاصة بالنظام (Dependency Injection)
            builder.Services.AddScoped<IAccountRepository, AccountRepository>();
            builder.Services.AddScoped<IAuthRepository, AuthRepository>();
            builder.Services.AddScoped<IInvoiceRepository, InvoiceRepository>();
            builder.Services.AddScoped<IProductRepository, ProductRepository>();
            builder.Services.AddScoped<IContactRepository, ContactRepository>();
            builder.Services.AddScoped<IVoucherRepository, VoucherRepository>();
            builder.Services.AddScoped<IJournalRepository, JournalRepository>(); // مستودع القيود الجديد
            builder.Services.AddScoped<PosService>();
            // 6. إعداد المصادقة وحماية الـ API عن طريق الـ JWT Tokens
            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8
                            .GetBytes(builder.Configuration.GetSection("Jwt:Key").Value ?? "ThisIsMyVeryLongAndSecureKeyForSmartBookSystem2026_MustBeLongerThan64Bytes")),
                        ValidateIssuer = true,
                        ValidIssuer = builder.Configuration["Jwt:Issuer"],
                        ValidateAudience = true,
                        ValidAudience = builder.Configuration["Jwt:Audience"]
                    };
                });

            var app = builder.Build();

            // --- إعداد الـ Middleware Pipeline (الترتيب حاسم جداً للـ الويب) ---

            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            // تفعيل الـ CORS بشكل صريح قبل الـ Routing والـ Authentication لمنع حظر متصفح كروم للطلب
            app.UseCors("AllowAll");

            // app.UseHttpsRedirection(); // معطل كما فضلت لتسهيل اتصالات الشبكة المحلية

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.MapControllers();

            app.Run();
        }
    }
}