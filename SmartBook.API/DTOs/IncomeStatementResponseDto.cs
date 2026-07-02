namespace SmartBook.API.DTOs
{
    public class IncomeStatementResponseDto
    {
        public List<IncomeStatementItemDto> Revenues { get; set; } = new();
        public List<IncomeStatementItemDto> CostOfSales { get; set; } = new();
        public List<IncomeStatementItemDto> Expenses { get; set; } = new();
        public List<IncomeStatementItemDto> OtherRevenues { get; set; } = new();
        public List<IncomeStatementItemDto> OtherExpenses { get; set; } = new();

        public double TotalRevenue => Revenues.Sum(x => x.Amount);
        public double TotalCostOfSales => CostOfSales.Sum(x => x.Amount);
        public double GrossProfit => TotalRevenue - TotalCostOfSales;
        public double OperatingExpenses => Expenses.Sum(x => x.Amount);
        public double OperatingIncome => GrossProfit - OperatingExpenses;
        public double OtherRevenueTotal => OtherRevenues.Sum(x => x.Amount);
        public double OtherExpenseTotal => OtherExpenses.Sum(x => x.Amount);
        public double NetProfit => OperatingIncome + OtherRevenueTotal - OtherExpenseTotal;
    }
}
