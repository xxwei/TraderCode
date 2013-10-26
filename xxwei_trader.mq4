//+------------------------------------------------------------------+
//|                                                 xxwei_trader.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#import "mql_xxwei.dll"
int XW_TimeControl();
int XW_TrendSignalControl(double ask,double bid,double high_1,double low_1,double open);
void XW_MA(double MA5_26,double MA5_14,double MA5_5);
void XW_MACD(double MACD5_1,double MACD5_0,double MACD60_1,double MACD60_0);
void XW_MACDSignal(double SMACD5_1,double SMACD5_0,double SMACD60_1,double SMACD60_0);
#import

int    CurrentTrend = OP_BUY;
double SingleOrderPosition = 0.1;
double AllPostionMaxLevel = 0.1;
int    MaxStopLess = 200;
int    CurrentSingal = 2;

//��󻬵�
extern int Slippage = 3;

//��ȡ��ǰ���ҶԲ�λ
double getPosition()
{
   double position;
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
         position += OrderLots();
      }
   }
   return (position);
}
//����
void OpenOrder(int nType,double postion)
{
   if(nType==OP_BUY)
       OrderSend(Symbol(),OP_BUY,postion,Ask,Slippage,0,0,"buy 1.0",255,0,CLR_NONE);
   if(nType==OP_SELL)
       OrderSend(Symbol(),OP_SELL,postion,Bid,Slippage,0,0,"Sell 1.0",255,0,CLR_NONE);
}
//ƽ��
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
            OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,CLR_NONE);
         if(OrderType()==OP_SELL)
            OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,CLR_NONE);
      }
   }
}   
void CloseOrder(int nType)
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
         if(OrderType()==nType)
         {
            if(nType==OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,CLR_NONE);
            if(nType==OP_SELL)
               OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,CLR_NONE);
         }
      }
   }  
}
void CloseOrderByIndex(int nType,int nIndex)
{

}
//�����ƶ�ֹ�� 
void MoveStopLess(int less)
{
   int OrderN =  OrdersTotal();
   for(int i = 0;i<OrderN;i++)
   {
      OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol()!=Symbol())
      {
         continue;
      }
      double stopless = OrderStopLoss();
      
      if (OrderType() == OP_BUY)
      {
         if(stopless==0.0)
         {
            Print(stopless+"------111");
            OrderModify(OrderTicket(),OrderOpenPrice(),Ask-Point*less,OrderTakeProfit(),0,Blue);
         } 
         else
         {
            if(Ask-stopless>less*Point+less/10*Point)
            {
                   Print(stopless+"------2222");
                 OrderModify(OrderTicket(),OrderOpenPrice(),Ask-Point*less,OrderTakeProfit(),0,Blue);
            }
         }
      }
      if(OrderType() == OP_SELL)
      {
         if(stopless==0.0)
         {
            Print(stopless+"------111");
            OrderModify(OrderTicket(),OrderOpenPrice(),Bid+Point*less,OrderTakeProfit(),0,Blue);
         } 
         else
         {
            if(stopless-Bid>less*Point+less/10*Point)
            {
                  Print(stopless+"------2222");
                 OrderModify(OrderTicket(),OrderOpenPrice(),Bid+Point*less,OrderTakeProfit(),0,Blue);
            }
         }
      }
  }
}
//+------------------------------------------------------------------+
//| �۸��쳣��� 
//| ����ֵ 0 ���쳣                  
//|        1 �����쳣                                                |
//|        2 �����쳣
//+------------------------------------------------------------------+
int PriceBeatABNormal()
{
   int order_type=100;
   int OrderN =  OrdersTotal();
   for(int i = 0;i<OrderN;i++)
   {
      OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol()!=Symbol())
      {
         continue;
      }
      order_type = OrderType();
   }
   int size = 16;
   double extent = 0.0;
   for(int j=1;j<16;j++)
   {
      extent = High[j]-Low[j]+extent;
   } 
   extent = extent/(size-1); 
   
   double currentextent =0.0;
   if(order_type==OP_BUY)
   {
      currentextent= MathAbs(Ask - Open[0]);
      if(Ask-Open[0]>0)
      {
            if(currentextent>2*extent)
            {
               Print("�쳣����buy 1");
               return (1);
            }
      }
      else
      {
            if(currentextent>2*extent)
            {
               Print("�쳣����buy 2");
               return (2);
            }
      }
   }
   else if(order_type==OP_SELL)
   {
       currentextent= MathAbs(Bid - Open[0]);
       if(Bid-Open[0]<0)
       {
            if(currentextent>2*extent)
            {
               Print("�쳣����sell 1");
               return (1);
            }
       }
       else
       {
            if(currentextent>2*extent)
            {
                Print("�쳣����sell 2");
               return (2);
            }
       }
   }
   else
   {
         currentextent= MathAbs(Ask - Open[0]);
         if(currentextent>2*extent)
         {
            Print("�쳣����000");
            return (1);
         }
   }
   //Print("���쳣����000---"+extent+"-----"+MathAbs(Ask - Open[0]));
   return (0);
}
//+------------------------------------------------------------------+
//| ʱ�����   
//| ����ֵ 0 ���Խ���                    (����) ƽ����ʱ������
//|        1 ���ܽ���                                                |
//|        2 ǿ��ƽ��
//+------------------------------------------------------------------+
int TimeControl()
{
   int TC = XW_TimeControl();
   return (TC);
}
//+------------------------------------------------------------------+
//| ��λ����
//|               0 ���Կ���
//|               1 ���ܿ���
//|               2 ��Ҫ����
//|               3 ��Ҫȫ��ƽ��                                                         |
//+------------------------------------------------------------------+
int PositionControl()
{
   double postion = getPosition();
   if(postion<0.2)
   {
      return (0);
   }
   return (1);
}
//+------------------------------------------------------------------+
//| ���տ���
//|               0 ƽ��
//|               1 ������                                                        |
//+------------------------------------------------------------------+
int RiskControl()
{
   return (1);
}
//+------------------------------------------------------------------+
//| �����ź�
//|               0 ��BUY�ź�
//|               1 ��SELL�ź�
//|               2 ���ź�
//|               3 ƽBUY�ź�
//|               4 ƽSELL�ź�
//|               5 �Ӳ�BUY�ź�
//|               6 �Ӳ�SELL�ź�                                           |
//+------------------------------------------------------------------+
int TrendSignalControl()
{
   double Macd5Value_0 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double Macd5Value_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double Macd60Value_0 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double Macd60Value_1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   XW_MACD(Macd5Value_1,Macd5Value_0,Macd60Value_1,Macd60Value_0);
   double Signal5Value_0 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   double Signal5Value_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   double Signal60Value_0 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   double Signal60Value_1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   XW_MACDSignal(Signal5Value_1,Signal5Value_0,Signal60Value_1,Signal60Value_0);
   double  MA26 = iMA(PERIOD_M5,0,26,0,MODE_EMA,PRICE_CLOSE,1);
   double  MA14 = iMA(PERIOD_M5,0,14,0,MODE_SMA,PRICE_MEDIAN,1);
   double  MA5 = iMA(PERIOD_M5,0,5,0,MODE_SMA,PRICE_MEDIAN,1);
   XW_MA(MA26,MA14,MA5);
   int nSignalType = XW_TrendSignalControl(Ask,Bid,High[1],Low[1],Open[0]);
   Print("�ź� "+nSignalType+" ��ǰ�ź� "+CurrentSingal);
   if(nSignalType==2)
   {
     // Print("���ź� 1");
   }
   if(nSignalType==CurrentSingal)
   {
      //Print("���ź� 2");
      return (2);
   }
   else
   {  
      
      CurrentSingal=nSignalType;
   }
   
   return  (nSignalType);
}
//+------------------------------------------------------------------+
//| ���Կ�ƽ�ֿ���                                                   |
//+------------------------------------------------------------------+
void TacticsOpenCloseOrder()
{
   if(RiskControl()==0)
   {
      CloseOrderAll();
   }
   else
   {
       int nTimeType = TimeControl();
       Print("ʱ�����"+nTimeType);
       if(nTimeType==2)
       {
           CloseOrderAll(); 
       }
       else if(nTimeType==1)
       {
            //��ǰʱ�䲻�ܽ���
       } 
       else
       {
           //Print("ʱ�����");
           int nPositionType = PositionControl();
           Print("��λ����"+nPositionType);
           if(nPositionType==3)
           {
               CloseOrderAll(); 
           }
           else if(nPositionType==2)
           {
               //��Ҫ����
               CloseOrderByIndex(CurrentTrend,0);
           }
           else if(nPositionType==1)
           {
               //��ǰ��λ���ܿ��� ���Լ���
               int AB1 = PriceBeatABNormal();
               Print("�쳣������"+AB1);
               if(AB1==2)
               {
                  CloseOrderAll(); 
               }
               else if(AB1==1)
               {
                   //��Ҫ���ݲ�λ��������ʲô����  
               }
               else
               {
                  int singnalType1 = TrendSignalControl();
                  if(singnalType1==0)
                  {
                     CloseOrder(OP_SELL);
                  }
                  if(singnalType1==1)
                  {
                     CloseOrder(OP_BUY);
                  }
                  if(singnalType1==2)
                  {
                     //ʲô������
                  }
                  if(singnalType1==3)
                  {
                     CloseOrder(OP_BUY);
                  }
                  if(singnalType1==4)
                  {
                     CloseOrder(OP_SELL);
                  }
               }
           }
           else
           {
               int AB = PriceBeatABNormal();
               Print("�쳣������"+AB);
               if(AB==2)
               {
                  CloseOrderAll(); 
               }
               else if(AB==1)
               {
                   //��Ҫ���ݲ�λ��������ʲô����  
               }
               else
               {
                  //Print("�쳣������");
                  int singnalType = TrendSignalControl();
                  if(singnalType==0)
                  {
                     CloseOrder(OP_SELL);
                     OpenOrder(OP_BUY,SingleOrderPosition);
                  }
                  if(singnalType==1)
                  {
                     CloseOrder(OP_BUY);
                     OpenOrder(OP_SELL,SingleOrderPosition);
                  }
                  if(singnalType==2)
                  {
                     //ʲô������
                  }
                  if(singnalType==3)
                  {
                     CloseOrder(OP_BUY);
                  }
                  if(singnalType==4)
                  {
                     CloseOrder(OP_SELL);
                  }
                  if(singnalType==5)
                  {
                     OpenOrder(OP_BUY,SingleOrderPosition);
                  }
                  if(singnalType==6)
                  {
                     OpenOrder(OP_SELL,SingleOrderPosition);
                  }
               }
           }
       } 
   }
   MoveStopLess(MaxStopLess);
}
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
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
   TacticsOpenCloseOrder();
//----
   return(0);
  }
//+------------------------------------------------------------------+