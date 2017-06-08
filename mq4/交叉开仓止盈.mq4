//+------------------------------------------------------------------+
//|                                                 交叉开仓止盈.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

extern      double slippage  = 30;    
datetime    last_cross_time;
//double      macd_buffer[];
bool        is_open;
extern      int  unit  = 120;
double      macd_buffer_1;
double      macd_buffer_2;
//+------------------------------------------------------------------+
//| 时间控制                                                         |
//+------------------------------------------------------------------+
int TimeControl()
{
     if(Hour()>=8&&Hour()<=21)
     {
         return (1);
     }
     return (0);
}
//+------------------------------------------------------------------+
//| 信号控制                                                         |
//+------------------------------------------------------------------+
int HaveSignal()
{
   int limit;
   int counted_bars=IndicatorCounted();
   //---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   double  MA14 = iMA(0,0,14,0,MODE_SMA,PRICE_MEDIAN,1);
   macd_buffer_1 = iMA(NULL,0,12,0,MODE_EMA,PRICE_CLOSE,1)-iMA(NULL,0,26,0,MODE_EMA,PRICE_CLOSE,1);
   macd_buffer_2 = iMA(NULL,0,12,0,MODE_EMA,PRICE_CLOSE,2)-iMA(NULL,0,26,0,MODE_EMA,PRICE_CLOSE,2);
   if(macd_buffer_2>0&&macd_buffer_1<0)
   {
      if(last_cross_time!=iTime(NULL,0,1))
      {
         last_cross_time = iTime(NULL,0,1);
         is_open = false;
      }
   }
   if(macd_buffer_2<0&&macd_buffer_1>0)
   {
      if(last_cross_time!=iTime(NULL,0,1))
      {
         last_cross_time = iTime(NULL,0,1);
         is_open = false;
      }
   }
   if(is_open==false)
   {
        if(macd_buffer_1>0&&Low[1]>MA14)
        {
            CloseOrderAll();
            return (1);
        }
        if(macd_buffer_1<0&&High[1]<MA14)
        {
            CloseOrderAll();
            return (2);
        }
   }
  
   return (0);     
}
//开仓
int  OpenOrder(int nType,double postion)
{
   int ret;
   if(nType==OP_BUY)
       ret = OrderSend(Symbol(),OP_BUY,postion,Ask,slippage,Ask-unit*Point,Ask+2*unit*Point,"buy 1.0",last_cross_time,0,CLR_NONE);
   if(nType==OP_SELL)
       ret = OrderSend(Symbol(),OP_SELL,postion,Bid,slippage,Bid+unit*Point,Bid-2*unit*Point,"Sell 1.0",last_cross_time,0,CLR_NONE);
   //int err=GetLastError();
   //Print("错误(",err,"): ",ErrorDescription(err));
   return (ret);
}
//平仓
void CloseOrderAll()
{
   int total=OrdersTotal();
   for(int pos=0;pos<total;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) 
      {
         continue;
      }
      else
      {
         if(OrderSymbol()!=Symbol())
         {
            continue;
         }
         if(OrderType()==OP_BUY)
            OrderClose(OrderTicket(),OrderLots(),Bid,slippage,CLR_NONE);
         if(OrderType()==OP_SELL)
            OrderClose(OrderTicket(),OrderLots(),Ask,slippage,CLR_NONE);
      }
   }
}
//修改止盈和异常平仓
void move_stop()
{
   int total=OrdersTotal();
   for(int pos=0;pos<total;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) 
      {
         continue;
      }
      else
      {
           int num  = OrderMagicNumber();
           if(num==0)
           {
               if(OrderStopLoss()>0)
               {
                  continue;
               }
               if(OrderType()==OP_BUY)
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask-unit*Point,Ask+5*unit*Point,0,CLR_NONE);
               }
               else
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid+unit*Point,Bid-5*unit*Point,0,CLR_NONE);
               }
           }
           else
           {
               if(num==last_cross_time)
               {
                  double TakeProfit = OrderTakeProfit();
                  double Profit = OrderProfit();
                  double SignalValue_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
                  
                  if(OrderType()==OP_BUY)
                  {
                     if(TakeProfit-Ask<=unit*Point)
                     {
                        if(SignalValue_1<macd_buffer_1)
                        {
                           if(macd_buffer_1>=macd_buffer_2)
                           {
                                OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss()+unit*Point,TakeProfit+unit*Point,0,CLR_NONE);
                           }
                        }
                     }
                     if(macd_buffer_1<macd_buffer_2)
                     {
                        if(SignalValue_1>macd_buffer_1)
                        {
                           CloseOrderAll();
                        }
                     }
                  }
                  if(OrderType()==OP_SELL)
                  {
                     if(Bid-TakeProfit<=unit*Point)
                     {
                        if(SignalValue_1>macd_buffer_1)
                        {
                           if(macd_buffer_1<=macd_buffer_2)
                           {
                                OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss()-unit*Point,TakeProfit-5*Point,0,CLR_NONE);
                           }
                        }
                      }
                     if(macd_buffer_1>macd_buffer_2)
                     {
                        if(SignalValue_1<macd_buffer_1)
                        {
                           CloseOrderAll();
                        }
                     } 
                  }
               }
               
           }
           
      }
    }
}
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

int init()
  {
//----
   last_cross_time = 0;
   is_open = true;
   macd_buffer_1 = 0.0;
   macd_buffer_2 = 0.0;
   Print("当前货币对:第一柱时间",iTime(NULL,0,0),Hour());
   Print("当前货币对:第一柱时间",iTime(NULL,0,1));
   Print("当前货币对:第一柱时间",iTime(NULL,0,2));
   Print("当前货币对:第一柱时间",iTime(NULL,0,3));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
  
   int ret = TimeControl();
   if(ret==1)
   {
      ret = HaveSignal();
      if(ret==1)
      {
         Print("开多仓信号");
         ret = OpenOrder(OP_BUY,0.1);
         if(ret>0)
         {
             is_open = true;
         }
      }
      else if(ret==2)
      {
         Print("开空仓信号");
          ret = OpenOrder(OP_SELL,0.1);
         if(ret>0)
         {
             is_open = true;
         }
      }
   }
   else
   {
      CloseOrderAll();
   }
   move_stop();
//----
   return(0);
  }
//+------------------------------------------------------------------+