//---- indicator parameters
#import "Speech.dll"
void InitSpeech();
void TextOutForSpeech(string ptext);
void TextOutForSpeechByInt(int i);
#import
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
double	high1;
double	high2;
double	high3;
double 	low1;
double	low2;
double	low3;

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
 									continue;
 								}
 								if(j==2)
 								{
 									low1 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==3)
 								{
 									high2 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==4)
 								{
 									low2 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==5)
 								{
 									high3 = ZigzagBuffer[i];
 									continue;
 								} 
 								if(j==6)
 								{
 									low3 = ZigzagBuffer[i];
 									//Print(high1,"--",high2,"--",high3,"--",low1,"--",low2,"--",low3);
 									break;
 								}
 						}
 						else
 						{
 								if(j==1)
 								{
 									low1 =ZigzagBuffer[i];
 									continue;
 								}
 								if(j==2)
 								{
 									high1 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==3)
 								{
 									low2 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==4)
 								{
 									high2 = ZigzagBuffer[i];
 									continue;
 								}
 								if(j==5)
 								{
 									low3 = ZigzagBuffer[i];
 									continue;
 								} 
 								if(j==6)
 								{
 									high3 = ZigzagBuffer[i];
 									//Print(high1,"--",high2,"--",high3,"--",low1,"--",low2,"--",low3);
 									break;
 								}
 						}
 						
 						
 				}
 		}	
}
void Step_Over()
{
		if(new_high)
		{
				if(Ask>high2)
				{
					step_over2 = false;
					step_over3 = false;
					step_over4 = false;
					if(step_over1==false)
					{
							step_over1 = true;
							Print(Symbol(),"跨越高点 1");
							TextOutForSpeechByInt(1);
					}
				}
				if(Bid<low1)
				{
					step_over1 = false;
					step_over3 = false;
					step_over4 = false;
					if(step_over2==false)
					{
							step_over2 = true;
							Print(Symbol(),"跨越低点 2");
							TextOutForSpeechByInt(2);
					}
				}
		}
		else
		{
				if(Ask>high1)
				{
					step_over1 = false;
					step_over2 = false;
					step_over4 = false;
					if(step_over3==false)
					{
							step_over3 = true;
							Print(Symbol(),"跨越高点 3");
							TextOutForSpeechByInt(3);
					}
				}
				if(Bid<low2)
				{
					step_over1 = false;
					step_over3 = false;
					step_over2 = false;
					if(step_over4==false)
					{
							step_over4 = true;
							Print(Symbol(),"跨越低点 4");
							TextOutForSpeechByInt(4);
					}
				}
		}
}

void Move_StopLess()
{
	int OrderN =  OrdersTotal();
	for(int i = 0;i<OrderN;i++)
	{
      OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol()!=Symbol())
      {
         continue;
      }
      if(OrderType()==OP_BUY)
      {
         if(new_high)
         {
            double stopless = OrderStopLoss();
            if(stopless<low1)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),low1,OrderTakeProfit(),0,Blue);
            }
         }
         else
         {
            stopless = OrderStopLoss();
            if(stopless<low2)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),low2,OrderTakeProfit(),0,Blue);
            }
         }
      }
      else if(OrderType()==OP_SELL)
      {
         if(new_high)
         {
            stopless = OrderStopLoss();
            if(stopless>high2)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),high2,OrderTakeProfit(),0,Blue);
            }
         }
         else
         {
            stopless = OrderStopLoss();
            if(stopless>high1)
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),high1,OrderTakeProfit(),0,Blue);
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
	InitSpeech();
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
//----
//	提醒价格越过高点或地点
		Step_Over();
//	订单止损单修改
//	下单后 止损位为上一个高点或低点 如果超过150个点位 则设在为150点
//  如果浮动盈利超过50点，止损位则修改为开仓为
//	如果最近的高点已经改变，止损价格也要修改 对应低点也一样
		Move_StopLess();
 		
 return(0);
} 