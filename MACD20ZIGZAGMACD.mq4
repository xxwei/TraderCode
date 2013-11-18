//+------------------------------------------------------------------+
//|                                             MACD20ZIGZAGMACD.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#import "Speech.dll"
void InitSpeech();
void TextOutForSpeech(string ptext);
void TextOutForSpeechByInt(int i);
#import

int	Slippage = 20;
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
//---- indicator buffers
double ZigzagBuffer[1000];
double HighMapBuffer[1000];
double LowMapBuffer[1000];
double BufChanelHigh[1000];
double BufChanelLow[1000];
int level=3; // recounting's depth
bool downloadhistory=false;
bool new_high = false;
bool can_open_postion = true;
double	high1;
double	high2;
double	high3;
double 	low1;
double	low2;
double	low3;
int      high1_pos;
int      high2_pos;
int      high3_pos;
int      low1_pos;
int      low2_pos;
int      low3_pos;

bool 		step_over1;
bool 		step_over2;
bool 		step_over3;
bool 		step_over4;
//=================================================================================================
void SetLowZZ(int pShift, double pValue) {
    ZigzagBuffer[pShift]=pValue;
    BufChanelLow[pShift]=pValue;
}
//=================================================================================================
void SetHighZZ(int pShift, double pValue) {
    ZigzagBuffer[pShift]=pValue;
    BufChanelHigh[pShift]=pValue;
}

int CalcZigZag()
{
	 int i, counted_bars = IndicatorCounted();
   int limit,counterZ,whatlookfor;
   int shift,back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   if(counted_bars<0)
   {
      counted_bars = 0;
   }
   if(counted_bars==0 && downloadhistory) // history was downloaded
   {
      ArrayInitialize(ZigzagBuffer,0.0);
      ArrayInitialize(BufChanelHigh,0.0);
      ArrayInitialize(BufChanelLow,0.0);
      ArrayInitialize(HighMapBuffer,0.0);
      ArrayInitialize(LowMapBuffer,0.0);
   }
   if (counted_bars==0) 
   {
      limit=Bars-ExtDepth;
      downloadhistory=true;
   }
   if (counted_bars>0) 
   {
      while (counterZ<level && i<100)
      {
         res=ZigzagBuffer[i];
         if (res!=0) counterZ++;
         i++;
      }
      i--;
      limit=i;
      if (LowMapBuffer[i]!=0) 
      {
         curlow=LowMapBuffer[i];
         whatlookfor=1;
      }
      else
      {
         curhigh=HighMapBuffer[i];
         whatlookfor=-1;
      }
      for (i=limit-1;i>=0;i--)  
      {
         ZigzagBuffer[i]=0.0;
         
         LowMapBuffer[i]=0.0;
         HighMapBuffer[i]=0.0;
         
         BufChanelHigh[i]=0.0;
         BufChanelLow[i]=0.0;
      }
   }
      
   for(shift=limit; shift>=0; shift--)
   {
      val=Low[iLowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
      { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
         {
            for(back=1; back<=ExtBackstep; back++)
            {
               res=LowMapBuffer[shift+back];
               if((res!=0)&&(res>val)) LowMapBuffer[shift+back]=0.0; 
            }
         }
      } 
      if (Low[shift]==val) LowMapBuffer[shift]=val; else LowMapBuffer[shift]=0.0;
      //--- high
      val=High[iHighest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
      {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
         {
            for(back=1; back<=ExtBackstep; back++)
            {
               res=HighMapBuffer[shift+back];
               if((res!=0)&&(res<val)) HighMapBuffer[shift+back]=0.0; 
            } 
         }
      }
      if (High[shift]==val) HighMapBuffer[shift]=val; else HighMapBuffer[shift]=0.0;
   }
 
   // final cutting 
   if (whatlookfor==0)
   {
      lastlow=0;
      lasthigh=0;  
   }
   else
   {
      lastlow=curlow;
      lasthigh=curhigh;
   }
   for (shift=limit;shift>=0;shift--)
   {
      res=0.0;
      switch(whatlookfor)
      {
         case 0: // look for peak or lawn 
            if (lastlow==0 && lasthigh==0)
            {
               if (HighMapBuffer[shift]!=0)
               {
                  lasthigh=High[shift];
                  lasthighpos=shift;
                  whatlookfor=-1;
                  SetHighZZ(shift, lasthigh);
                  res=1;
               }
               if (LowMapBuffer[shift]!=0)
               {
                  lastlow=Low[shift];
                  lastlowpos=shift;
                  whatlookfor=1;
                  SetLowZZ(shift, lastlow);
                  res=1;
               }
            }
            break;  
         case 1: // look for peak
            if (LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<lastlow && HighMapBuffer[shift]==0.0)
            {
               SetLowZZ(lastlowpos, 0.0);
               lastlowpos=shift;
               lastlow=LowMapBuffer[shift];
               SetLowZZ(shift, lastlow);
               res=1;
            }
            if (HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
            {
               lasthigh=HighMapBuffer[shift];
               lasthighpos=shift;
               SetHighZZ(shift, lasthigh);
               whatlookfor=-1;
               res=1;
            }   
            break;               
         case -1: // look for lawn
            if (HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>lasthigh && LowMapBuffer[shift]==0.0)
            {
               SetHighZZ(lasthighpos, 0.0);
               lasthighpos=shift;
               lasthigh=HighMapBuffer[shift];
               SetHighZZ(shift, lasthigh);
            }
            if (LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
            {
               lastlow=LowMapBuffer[shift];
               lastlowpos=shift;
               SetLowZZ(shift, lastlow);
               whatlookfor=1;
            }   
            break;               
         default: return; 
        }
     }
 
   return(0);
}
void CalcForZigZag()
{
		int		cur_high;
 		int		cur_low;

 		
 		for(int i=0;i<1000;i++)
 		{     
 				if(HighMapBuffer[i]!=0)
 				{
 						cur_high = i;
 						break;
 				}
 		}
		for(i=0;i<1000;i++)
 		{
 				if(LowMapBuffer[i]!=0)
 				{
 						cur_low = i;
 						break;
 				}
 		}
 		//Print("cur_low",cur_low,"cur_high",cur_high);	
 		if(cur_low<cur_high)
 		{
 				//最近为低点
 				new_high = false;
 				//Print("最近为低点");
 		}
 		if(cur_low>cur_high)
 		{
 				//最近为高点
 				new_high = true;
 				//Print("最近为高点");
 		}
 		int 	j = 0;
 		for(i=0;i<1000;i++)
 		{
 		      
 				if(ZigzagBuffer[i]!=0)
 				{
 				      //Print("ZigZagBuffer",i,"---",ZigzagBuffer[i]);
 				      j++;
 						if(new_high)
 						{
 								if(j==1)
 								{
 									high1 =ZigzagBuffer[i];
 									high1_pos= i;
 									continue;
 								}
 								if(j==2)
 								{
 									low1 = ZigzagBuffer[i];
 									low1_pos = i;
 									continue;
 								}
 								if(j==3)
 								{
 									high2 = ZigzagBuffer[i];
 									high2_pos = i;
 									continue;
 								}
 								if(j==4)
 								{
 									low2 = ZigzagBuffer[i];
 									low2_pos = i;
 									continue;
 								}
 								if(j==5)
 								{
 									high3 = ZigzagBuffer[i];
 									high3_pos = i;
 									continue;
 								} 
 								if(j==6)
 								{
 									low3 = ZigzagBuffer[i];
 									low3_pos = i;
 									//Print(high1,"--",high2,"--",high3,"--",low1,"--",low2,"--",low3);
 									break;
 								}
 						}
 						else
 						{
 								if(j==1)
 								{
 									low1 =ZigzagBuffer[i];
 									low1_pos = i;
 									continue;
 								}
 								if(j==2)
 								{
 									high1 = ZigzagBuffer[i];
 									high1_pos = i;
 									continue;
 								}
 								if(j==3)
 								{
 									low2 = ZigzagBuffer[i];
 									low2_pos = i;
 									continue;
 								}
 								if(j==4)
 								{
 									high2 = ZigzagBuffer[i];
 									high2_pos = i;
 									continue;
 								}
 								if(j==5)
 								{
 									low3 = ZigzagBuffer[i];
 									low3_pos = i;
 									continue;
 								} 
 								if(j==6)
 								{
 									high3 = ZigzagBuffer[i];
 									high3_pos = i;
 									//Print(high1,"--",high2,"--",high3,"--",low1,"--",low2,"--",low3);
 									break;
 								}
 						}
 						
 						
 				}
 		}	
}
//开仓
void OpenOrder(int nType,double postion,int magic)
{
   if(nType==OP_BUY)
       OrderSend(Symbol(),OP_BUY,postion,Ask,Slippage,0,0,"buy 1.0",magic,0,CLR_NONE);
   if(nType==OP_SELL)
       OrderSend(Symbol(),OP_SELL,postion,Bid,Slippage,0,0,"Sell 1.0",magic,0,CLR_NONE);
}
void CloseOrder(int nType,int magic)
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
         //Print("Pre Close-----",OrderType(),"----",OrderMagicNumber(),"--",magic);
         if(OrderType()==nType&&OrderMagicNumber()==magic)
         {
            //Print("Pre Close");
            if(nType==OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,CLR_NONE);
            if(nType==OP_SELL)
               OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,CLR_NONE);
         }
      }
   }  
}
void MoveStopLoss(int maxLoss)
{
   //1 设置初始止损位
   //2 每隔100点移动一次
   int OrderN =  OrdersTotal();
   double low_value;
   double high_value;
   if(new_high)
   {
      low_value = low1;
      high_value = high2;
   }
   else
   {
      low_value = low2;
      high_value = high1;
   }
	for(int i = 0;i<OrderN;i++)
	{
      OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol()!=Symbol())
      {
         continue;
      }
      if(OrderType()==OP_BUY)
      {
         double stopless1 = OrderStopLoss();       
         if(stopless1==0)
         {
            //设置初始止损位
            if(Bid-low_value<maxLoss*Point)
            {
               if(Bid-low_value<50*Point)
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Bid-50*Point,OrderTakeProfit(),0,Blue);
               }
               else
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),low_value,OrderTakeProfit(),0,Blue);
               }
            }
            else
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-maxLoss*Point,OrderTakeProfit(),0,Blue);
            }
         }
         else
         {
            if(Bid-stopless1>maxLoss*2*Point)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),Bid-maxLoss*Point,OrderTakeProfit(),0,Blue);
            }
         }
      }
      if(OrderType()==OP_SELL)
      {
         double stopless2 = OrderStopLoss();
         if(stopless2==0)
         {
            //设置初始止损位
            if(high_value-Ask<maxLoss*Point)
            {
               if(high_value-Ask<50*Point)
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Ask+50*Point,OrderTakeProfit(),0,Blue);
               }
               else
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),high_value,OrderTakeProfit(),0,Blue);
               }
            }
            else
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+maxLoss*Point,OrderTakeProfit(),0,Blue);
            }
         }
         else
         {
            if(stopless2-Ask>maxLoss*2*Point)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),Ask+maxLoss*Point,OrderTakeProfit(),0,Blue);
            } 
         }
      }
   }
   
}
void AutoTrader()
{
   double Macd5Value_0 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double Macd5Value_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double Macd5Signal_0 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   double Macd5Signal_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   double  MA20_1 = iMA(PERIOD_M5,0,20,0,MODE_SMA,PRICE_MEDIAN,1);
   double  MA20_2 = iMA(PERIOD_M5,0,20,0,MODE_SMA,PRICE_MEDIAN,2);
   if(Macd5Value_0>0&&Macd5Value_1<0)
   {
      if(MA20_2<MA20_1)
      {
         if(Bid>Macd5Value_1&&can_open_postion)
         {
            TextOutForSpeechByInt(7);
            can_open_postion = false;
         }
      }
   }
   if(Macd5Value_0<0&&Macd5Value_1>0)
   {
      if(MA20_2>MA20_1)
      {
         if(Ask<Macd5Value_1&&can_open_postion)
         {
            TextOutForSpeechByInt(8);
            can_open_postion = false;
         }
      }
   }
   if(Low[1]>MA20_1&&Macd5Value_1>Macd5Signal_1)
   {
      if(MA20_2<MA20_1&&can_open_postion)
      {
         TextOutForSpeechByInt(7);
         can_open_postion = false;
      }
   }
   if(High[1]<MA20_1&&Macd5Value_1<Macd5Signal_1)
   {
      if(MA20_2<MA20_1&&can_open_postion)
      {
         TextOutForSpeechByInt(8);
         can_open_postion = false;
      }
   }
   
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
   
   CalcZigZag();
   CalcForZigZag();
   AutoTrader();
   MoveStopLoss(150);
//----
   return(0);
  }
//+------------------------------------------------------------------+