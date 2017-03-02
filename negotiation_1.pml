mtype = {quoReq, quote,offer,reject,offAck,accept,accAck,revReq,revRej,revAcc,authzing,authzed,authzFail,termi, accReq, accRes, contracted, uncontracted, terManager};

typedef Msg1 { int id;
              mtype tp;
              byte mno;
};
typedef Msg2 { int id;
               mtype tp;
               byte mno;
               byte grole;
};
typedef Msg3{ int id;
              mtype mt;
              byte mn;
              int dec;
};

chan toU = [0] of {Msg1};
chan toP = [0] of {Msg1};
chan toO = [0] of {Msg2};
chan toPO = [0] of {Msg3};


proctype User(){

byte mbit;
int id;

          do
          :: toP!quoReq(id, mbit) -> 
             printf("user sent quoReq %d\n", mbit);
             mbit++;
             if
             :: toU?quote(id, mbit);
                printf("user received quote %d\n", mbit);
                mbit++;
                goto negotiating
             :: timeout
             fi
          od; 
          
negotiating:  do
              :: toP!offer(id, mbit) ->
                 printf("user sent offer %d\n", mbit);
                 mbit++;
                 if
                 :: toU?offAck(id, mbit);
                    printf("user recevied offAck %d\n", mbit);
                    mbit++;
                    goto contracting5
                 :: toU?termi(id, mbit) ->
end2:               printf("user received termi negotiation %d\n", mbit);
                    break
                 :: toP!revReq(id, mbit) ->
                    printf("user sent revoke request after receiving offer %d\n", mbit);
                    mbit++;
                    goto revoking1
                 :: toP!termi(id, mbit) ->
end1:               printf("user sent termi negotiation %d\n", mbit) ->
                    break
                 :: timeout
                 fi
                 
              od;

revoking1:  do
            
           
              :: toU?revRej(id, mbit) ->
                 printf("user received revoke reject1 %d\n", mbit);
                 mbit++;
                 goto revDeny1
              :: toU?revAcc(id, mbit) ->
                 printf("user received revoke accept1 %d\n", mbit);
                 break
              :: toU?termi(id, mbit) ->              
end3:            printf("user received termi negotiation %d\n", mbit);
                 break
              :: toP!termi(id, mbit) ->
end4:            printf("user sent termi negotiation %d\n", mbit);
                 break
              :: timeout
              
              
          od;
          
revDeny1: do
           
             :: toU?offAck(id, mbit) ->
                printf("user sent offAck revDeny1 %d\n", mbit);
                mbit++;
                goto contracting1
             :: toU?termi(id, mbit) ->            
end5:           printf("user received termi revDeny1 %d\n", mbit) ->
                break
             :: toP!termi(id, mbit) ->
end6:           printf("user sent termi revDeny1 %d\n", mbit);
                break
             :: timeout
             

     od;
            
contracting1:  do
                
               
                  :: toU?authzing(id, mbit);
                     printf("user received authzing contracting1 %d\n", mbit);
                     mbit++;
                     if
                     :: toU?authzed(id, mbit) ->
                        mbit++;
                        printf("user received authzed contracting1 %d\n", mbit);
                        goto authzed1
                     :: toU?authzFail(id, mbit) ->
end533:                 printf("user received authzFail contracting1 %d\n", mbit);
                        break
                     :: toU?termi(id, mbit);
end510:                 printf("user received authzing contracting1 %d\n", mbit);
                        break
                     :: toP!revReq(id, mbit) ->
                        mbit++;
                        if
                        :: toU?revRej(id, mbit) ->
                           printf("user received revRej authzing contracting1 %d\n", mbit);
                           mbit++;
                           goto authzzing1
                        :: toU?revAcc(id, mbit) ->
end511:                    printf("user received revAcc authzing contracting1 %d\n", mbit);
                           break
                        :: toU?termi(id, mbit) ->
end512:                    printf("user received termi authzing contracting1 %d\n", mbit);
                           break
                        :: toP!termi(id, mbit) ->
end513:                    printf("user sent authzing contracting1 %d\n", mbit);
                           break
                        :: timeout
                        fi
                     :: toP!termi(id, mbit) ->
end514:                 printf("user sent termi authzing contracting1 %d\n", mbit);
                        break
                     :: timeout
                     fi
                  :: toU?termi(id, mbit) ->
end530:              printf("user received termi authzing %d\n", mbit);
                     break
                  :: toP!revReq(id, mbit);
                     printf("user sent revReq contracting1 %d\n", mbit);
                     mbit++;
                     if
                          :: toU?revAcc(id, mbit) ->
end63:                       printf("user revoke accpeted after offAck contracting1 %d\n", mbit);
                             break
                          :: toU?revRej(id, mbit) ->
                             printf("user received revRej contracting1%d\n", mbit);
                             mbit++;
                             goto contracting6
                          :: toU?termi(id, mbit) ->
end64:                       printf("user received termi authzedRej contracting1 %d\n", mbit);
                             break
                          :: toP!termi(id, mbit) ->
end65:                       printf("user sent termi authzedRejcontracting1 %d\n", mbit);
                             break
                          :: timeout
                          fi 
                  :: toP!termi(id, mbit) ->
end16:               printf("user sent termi contracting1 %d\n", mbit);
                     break
                  :: timeout

               od;
 
authzzing1:   do
              
             
               :: toU?authzed(id, mbit);
                  printf("user received authzed1 %d\n", mbit);
                  mbit++;
                  goto contracting2
               :: toU?authzFail(id, mbit);
end17:            printf("user received authzFail1 %d\n", mbit);
                  break
               :: toU?termi(id, mbit) ->
end18:            printf("user received termi contracting1 %d\n", mbit);
                  break
               :: toP!termi(id, mbit) ->
end19:            printf("user sent termi contracting1 %d\n", mbit);
                  break
               :: timeout
               
               
           od;

contracting5:  do
                    
                
                       :: toU?authzing(id, mbit);
                           mbit++;
                           printf("user received authzing contracting5 %d\n", mbit);
                           if
                           :: toU?authzed(id, mbit) ->
                              mbit++;
                              printf("user received authzed contracting5 %d\n", mbit);
                              goto authzed1
                           :: toU?authzFail(id, mbit)->
end532:                       printf("user received authzFail contracting5 %d\n", mbit);
                              break
                           :: toU?termi(id, mbit) ->
end29:                        printf("user received termi authzed contracting5 %d\n", mbit);
                              break
                           :: toP!revReq(id, mbit) ->
                              printf("user sent revReq authzing contracting5 %d\n", mbit);
                              mbit++;
                              if
                              :: toU?revRej(id, mbit) ->
                                 printf("user received revRej authzing contracting5 %d\n", mbit);
                                 mbit++;
                                 goto authzzing3
                              :: toU?termi(id, mbit) ->
end506:                          printf("user received termi authzing contracting5 %d\n", mbit);
                                 break
                              :: toU?revAcc(id, mbit) ->
end507:                          printf("user received revAcc authzing contracting5 %d\n", mbit);
                                 break
                              :: toP!termi(id, mbit) ->
end508:                          printf("user sent termi authzing contracting5 %d\n", mbit);
                                 break
                              :: timeout
                              fi
                           :: toP!termi(id, mbit) ->
end509:                       printf("user sent termi authzing contracting5 %d\n", mbit);
                              break
                           :: timeout
                           fi
                        :: toU?termi(id, mbit) ->
end531:                    printf("user received termi authzing contracting5 %d\n", mbit);
                           break
                        :: toP!revReq(id, mbit) ->
                           printf("user sent revReq contracting5 %d\n", mbit);
                           mbit++;
                           if
                           :: toU?revAcc(id, mbit) ->
end9000:                      printf("user received revReq contracting5 %d\n", mbit);
                              break
                           :: toU?revRej(id, mbit) ->
                              printf("user received revRej contracting5 %d\n", mbit);
                              mbit++;
                              goto contracting6
                           :: toU?termi(id, mbit) ->
end9001:                      printf("user received termi contracting5 %d\n", mbit);
                              break
                           :: toP!termi(id, mbit) ->
end9002:                      printf("user sent termi contracting5 %d\n", mbit);
                              break
                           :: timeout
                           fi
                        :: toP!termi(id, mbit) ->
end30:                     printf("user sent termi contracting5 %d\n", mbit);
                           break
                        :: timeout
                        
                       
                 od;

authzzing3:  do
              
             
                :: toU?authzed(id, mbit) ->
                   mbit++;
                   goto authzed1
                :: toU?authzFail(id, mbit);
end34:             printf("user received authzFail authzzing3 %d\n", mbit);
                   break
                :: toU?termi(id, mbit) ->
end35:             printf("user received termi authzzing3 %d\n", mbit);
                   break
                :: toP!termi(id, mbit) ->
end36:             printf("user sent termi authzzing3 %d\n", mbit);
                   break
                :: timeout
                
             od;

             
authzed1:  do
            
           
              :: toU?accept(id, mbit) ->
                 mbit++;
                 printf("user received accept authzed1 %d\n", mbit);
                 if
                 :: toU?termi(id, mbit) ->
end48:              printf("user received termi authzed1 %d\n", mbit);
                    break
                 :: toP!revReq(id, mbit) ->
                    mbit++;
                    printf("user sent revReq authzed1 %d\n", mbit);
                    if
                    :: toU?revRej(id, mbit) ->
                       mbit++;
                       printf("user received recRej authzed1 %d\n", mbit);
                       if
                       :: toU?termi(id, mbit) ->
end304:                   printf("user received accAck termi authzed1 %d\n", mbit);
                          break
                       :: toP!accAck(id, mbit);
end43:                    printf("user sent accAck revAccept authzed1 %d\n", mbit);
                          break
                       :: toP!termi(id, mbit) ->
end305:                   printf("user sent accAck termi authzed1 %d\n", mbit);
                          break
                       :: timeout
                       fi
                    :: toU?revAcc(id, mbit) ->
end44:                 printf("user received revAcc authzed1 %d\n", mbit);
                       break
                    :: toU?termi(id, mbit) ->
end45:                 printf("user received termi authzed1 %d\n", mbit);
                       break
                    :: toP!termi(id, mbit) ->
end46:                 printf("user sent termi authzed1 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toP!accAck(id, mbit) ->
end47:              printf("user sent accAck authzed1 %d\n", mbit);
                    break
                 :: toP!termi(id, mbit) ->
end49:              printf("user sent termi authzed1 %d\n", mbit);
                    break
                 :: timeout
                 fi
              :: toU?reject(id, mbit) ->
end50:           printf("user received reject authzed1 %d\n", mbit);
                 break
              :: toP!revReq(id, mbit) ->
                 mbit++;
                 if
                 :: toU?revRej(id, mbit) ->
                    mbit++;
                    printf("user received revoke reject authzed1 %d\n", mbit);
                    goto authzedRej
                 :: toU?revAcc(id, mbit) ->
end40:              printf("user received recAcc authzed1 %d\n", mbit);
                    break
                 :: toU?termi(id, mbit) ->
end41:              printf("user received termi authzed1 %d\n", mbit);
                    break
                 :: toP!termi(id, mbit) ->
end42:              printf("user sent termi authzed1 %d\n", mbit);
                    break
                 :: timeout
                 fi
              :: toU?termi(id, mbit) ->
end51:           printf("user received termi authzed1 %d\n", mbit);
                 break
              :: toP!termi(id, mbit) ->
end52:           printf("user sent termi authzed1 %d\n", mbit);
                 break
              :: timeout
              
          od;

authzedRej:  do
             
              
                :: toU?accept(id, mbit) ->
                   printf("user received accept authzedRej %d\n", mbit);
                   mbit++;
                   if
                   :: toU?termi(id, mbit) ->
end58:                printf("user received termi authzedRej %d\n", mbit);
                      break
                   :: toP!revReq(id, mbit) ->
                      mbit++;
                      printf("user sent revReq authzedRej %d\n", mbit);
                      if
                      :: toU?revRej(id, mbit) ->
                         printf("user received revRej authzedRej %d\n", mbit);
                         mbit++;
                         if
                         :: toU?termi(id, mbit) ->
end318:                     printf("user received accAck termi authzedRej %d\n", mbit);
                            break
                         :: toP!accAck(id, mbit);
end53:                      printf("user sent accAck revAccept authzedRej %d\n", mbit);
                            break
                         :: toP!termi(id, mbit) ->
end306:                     printf("user sent accAck termi authzedRej %d\n", mbit);
                            break
                         :: timeout
                         fi
                      :: toU?revAcc(id, mbit) ->
end54:                   printf("user received revAcc authzedRej %d\n", mbit);
                         break
                      :: toU?termi(id, mbit) ->
end55:                   printf("user received termi authzedRej %d\n", mbit);
                         break
                      :: toP!termi(id, mbit) ->
end56:                   printf("user sent termi authzedRej %d\n", mbit);
                         break
                      :: timeout
                      fi
                   :: toP!accAck(id, mbit) ->
end57:                printf("user sent accAck authzedRej %d\n", mbit);
                      break
                   :: toP!termi(id, mbit) ->
end59:                printf("user sent termi authzedRej %d\n", mbit);
                      break
                   :: timeout
                   fi
                :: toU?reject(id, mbit) ->
end60:             printf("user received reject authzedRej %d\n", mbit);
                   break
                :: toU?termi(id, mbit) ->
end61:             printf("user received termi authzedRej %d\n", mbit);
                   break
                :: toP!termi(id, mbit) ->
end62:             printf("user sent termi authzedRej %d\n", mbit);
                   break
                :: timeout
                
            od;

contracting6:  do
               
               
                  :: toU?authzing(id, mbit);
                     printf("user received authzing contracting6 %d\n", mbit);
                     mbit++;
                     if
                     :: toU?authzed(id, mbit) ->
                        mbit++;
                        printf("user received authzed contracting6 %d\n", mbit);
                        goto authzed1
                     :: toU?authzFail(id, mbit) ->
end534:                 printf("user received authzed contracting6 %d\n", mbit);
                        break
                     :: toU?termi(id, mbit) ->
end74:                  printf("user received termi contracting6 %d\n", mbit);
                        break
                     :: toP!revReq(id, mbit) ->
                        printf("user sent revReq authzing contracting5 %d\n", mbit);
                        mbit++;
                              if
                              :: toU?revRej(id, mbit) ->
                                 printf("user received revRej authzing contracting5 %d\n", mbit);
                                 mbit++;
                                 goto authzzing3
                              :: toU?termi(id, mbit) ->
end520:                          printf("user received termi authzing contracting5 %d\n", mbit);
                                 break
                              :: toU?revAcc(id, mbit) ->
end521:                          printf("user received revAcc authzing contracting5 %d\n", mbit);
                                 break
                              :: toP!termi(id, mbit) ->
end522:                          printf("user sent termi authzing contracting5 %d\n", mbit);
                                 break
                              :: timeout
                              fi
                     :: toP!termi(id, mbit) ->
end524:                 printf("user sent termi authzing contracting5 %d\n", mbit);
                        break
                     :: timeout
                     fi 
                  :: toU?termi(id, mbit) ->
end8001:             printf("user received termi contracting6 %d\n", mbit);
                     break
                  :: toP!termi(id, mbit) ->
end75:               printf("user sent termi contracting6 %d\n", mbit);
                     break
                  :: timeout                 
               od;

            
contracting2:   do
                
                  :: toU?reject(id, mbit) ->
end85:               printf("user received rejected after authzzing contracting2 %d\n", mbit);
                     break
                  :: toU?accept(id, mbit) ->
                     mbit++;
                     printf("user received acccpted after authzzing contracting2 %d\n", mbit);
                     if
                     :: toU?termi(id, mbit) ->
end91:                  printf("user received termi contracting2 %d\n", mbit);
                        break
                     :: toP!revReq(id, mbit) ->
                        printf("user sent revReq contracting2 %d\n", mbit);
                        mbit++;
                        if
                        :: toU?revRej(id, mbit) ->
                           mbit++;
                           printf("user received revRej contracting2 %d\n", mbit);
                           if
                           :: toU?termi(id, mbit) ->
end309:                   printf("user received accAck termi contracting2 %d\n", mbit);
                          break
                           :: toP!accAck(id, mbit);
end86:                    printf("user sent accAck revAccept contracting2 %d\n", mbit);
                          break
                           :: toP!termi(id, mbit) ->
end310:                   printf("user sent accAck termi contracting2 %d\n", mbit);
                          break
                           :: timeout
                           fi
                        :: toU?revAcc(id, mbit) ->
end87:                     printf("user received revAcc contracting2 %d\n", mbit);
                           break
                        :: toU?termi(id, mbit) ->
end88:                     printf("user received termi contracting2 %d\n", mbit);
                           break
                        :: toP!termi(id, mbit) ->
end89:                     printf("user sent termi contracting2 %d\n", mbit);
                           break
                        :: timeout
                        fi
                     :: toP!accAck(id, mbit) ->
end90:                  printf("user sent accAck when contracting2 %d\n", mbit);
                        break
                     :: toP!termi(id, mbit) ->
end92:                  printf("user sent termi contracting2 %d\n", mbit);
                        break
                     :: timeout
                     fi
                  :: toU?termi(id, mbit) ->
end93:               printf("user received termi contracting2 %d\n", mbit);
                     break
                  :: toP!revReq(id, mbit) ->
                     mbit++;
                     if
                     :: toU?revRej(id, mbit) ->
                        mbit++;
                        printf("user sent recReq after authzed contracting2 %d\n", mbit);
                        goto authzedRej
                     :: toU?revAcc(id, mbit) ->
end84:                  printf("user received revAcc contracting2 %d\n", mbit); 
                        break
                     :: toU?termi(id, mbit) ->
end130:                 printf("user received termi contracting2 %d\n", mbit);
                        break
                     :: toP!termi(id, mbit) ->
end131:                 printf("user sent termi contracting2 %d\n", mbit);
                        break
                     :: timeout
                     fi
                  :: toP!termi(id, mbit) ->
end94:               printf("user sent termi contracting2 %d\n", mbit);
                     break
                  :: timeout
               od;               

}


proctype AS(){
int id;
byte grole;
byte abit;


    do
    
    :: toO?accReq(id,abit,grole) ->
       printf("AC received accReq %d\n", abit);
       abit++;
       if
       :: toPO!accRes(id, abit, 0) ->
          abit++;
          printf("AC sent provider 0 as access accept %d\n", abit);
          if
          :: toO?contracted(id, abit, grole) ->
end1:        printf("AC received contracted confirmation from provider %d\n", abit);
             break
          :: toO?uncontracted(id, abit, grole) ->
end4:        printf("AC received uncontracted from provider %d\n", abit);
             break
          :: toPO!terManager(id, abit, 1) ->
end5:        printf("AC sent terminatie to provider after access proved %d\n", abit);
             break
          :: timeout
          fi
       :: toPO!accRes(id, abit, 1) ->
end2:     printf("AC sent provider 1 as access deny %d\n", abit);
          break
       :: toO?uncontracted(id, abit, grole) ->
end3:     printf("AC received provider terminate when making decision %d\n", abit);
          break
       :: timeout
       fi
    :: timeout
    
    od;
}



proctype Pro(){

byte mbit;
int id;
byte abit;
byte grole;

         do
        
         :: toP?quoReq(id, mbit) -> mbit++;
            toU!quote(id, mbit);
            printf("provider sent quote %d\n", mbit);
            goto negotiating
         :: timeout
         
         od;  
      
negotiating:  do
              
                 ::toP?offer(id, mbit);
                 mbit++;
                 printf("provider received offer %d\n", mbit);
                 goto afterOff
                 :: timeout
                 

              od;
 
afterOff:  do
            
                    :: toP?revReq(id, mbit) ->
                       printf("provider received revoke request after offer %d\n", mbit);
                       mbit++;
                       goto revoking1 
                    :: toP?termi(id, mbit) ->
end1:                  printf("provider received termi afterOff %d\n", mbit);
                       break
                    :: toU!offAck(id, mbit) ->
                       printf("provider sent offerAck %d\n", mbit);
                       mbit++;
                       goto contracting2
                    :: toU!termi(id, mbit) ->
end2:                  printf("provider received termi afterOff %d\n", mbit);
                       break
                    :: timeout
                    
            
           od;

revoking1:  do
            
           
              :: toP?termi(id, mbit) ->
end4:            printf("provider received termi revoking1 %d\n", mbit);
                 break
              :: toU!revAcc(id, mbit) ->
end3:            printf("provider accepted revoke request revoking1 %d\n", mbit);
                 break
              :: toU!revRej(id, mbit) ->
                 printf("provider received revRej revoking1 %d\n", mbit);
                 mbit++;
                 toU!offAck(id, mbit) ->
                 printf("provider sent offerAck after revoke deny revoking1 %d\n", mbit);
                 mbit++;
                 goto contracting1
              :: toU!termi(id, mbit) ->
end5:            printf("provider received termi revoking1 %d\n", mbit);
                 break
              :: timeout
              
           od;

contracting1:  do
              
                 :: toP?revReq(id, mbit) ->
                    printf("provider received revoke request contracting1 %d\n", mbit);
                    mbit++;
                    if
                    :: toP?termi(id, mbit) ->
end7:                  printf("provider received termi contracting1 %d\n", mbit);
                       break
                    :: toU!revAcc(id, mbit) ->
end6:                  printf("provider accepted revoke request contracting1 %d\n", mbit);
                       break
                    :: toU!revRej(id, mbit) ->
                       printf("provider deny revoke request contracting1 %d\n", mbit);
                       mbit++;
                       goto contracting3
                    :: toU!termi(id, mbit) ->
end8:                  printf("provider received termi contracting1 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toP?termi(id, mbit) ->
end17:              printf("provider received termi contracting1 %d\n", mbit);
                    break
                 :: toU!authzing(id, mbit) ->
                    printf("provider sent authzing contracting1 %d\n", mbit);
                    mbit++;
                    if
                    :: toP?termi(id, mbit) ->
end6002:               printf("provider received termi contracting1 %d\n", mbit);
                       break
                    :: toO!accReq(id, abit, grole) ->
                       printf("provider sent accReq contracting1 %d\n", mbit);
                       abit++;
                       goto accessNeg
                    :: toU!termi(id, mbit) ->
end6003:               printf("provider sent termi contracting1 %d\n", mbit);
                       break
                    :: timeout
                    fi 
                 :: toU!termi(id, mbit) ->
end18:              printf("provider received termi contracting1 %d\n", mbit);
                    break
            
                 :: timeout
              od;

accessNeg:     do
                   
                    :: toP?revReq(id, mbit) ->
                       printf("provider sent authzing contracting1 %d\n", mbit);
                       mbit++;
                       if
                       :: toP?termi(id, mbit) ->
                          toO!uncontracted(id, abit, grole);
end206:                   printf("provider received termi authzing contracting1 %d\n", mbit);
                          break
                       :: toU!revRej(id, mbit) ->
                          printf("provider sent revRej authzing contracting1 %d\n", mbit);
                          mbit++;
                          goto authzNeg4
                       :: toU!termi(id, mbit) ->
                          toO!uncontracted(id, abit, grole);
end205:                   printf("provider sent termi contracting1 %d\n", mbit);
                          break
                       :: toU!revAcc(id, mbit) ->
end207:                   printf("provider sent revAcc authzing contracting1 %d\n", mbit);
                          break
                       :: timeout
                       fi
                    :: toP?termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end215:                printf("provider received termi authzing contracting1 %d\n", mbit);
                       break
                    :: toPO?accRes(id, abit, 0) ->
                       abit++;
                          printf("provider received agree from AC %d\n", abit);
                          if
                          :: toP?termi(id, mbit) ->
                             toO!uncontracted(id, abit, grole);
end1005:                     printf("provider received termi authzzing %d\n", mbit);
                             break
                          :: toP?revReq(id, mbit) ->
                             mbit++;
                             if
                             :: toP?termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end2051:                        printf("provider sent revAcc to user %d\n", mbit);
                                break
                             :: toPO?terManager(id, abit, 1) ->
                                toU!termi(id, mbit);
end2055:                        printf("provider received termi from manager and sent it to user %d\n", mbit);
                                break
                             :: toU!revRej(id, mbit) ->
                                mbit++;
                                if
                                :: toP?termi(id, mbit) ->
                                   toO!uncontracted(id, abit, grole);
end2053:                           printf("provider received termi to user %d\n", mbit);
                                   break
                                :: toPO?terManager(id, abit, 1) ->
                                   toU!termi(id, mbit);
end2056:                           printf("provider received termi from manager and sent it to user %d\n", mbit);
                                   break
                                :: toU!termi(id, mbit) ->
                                   toO!uncontracted(id, abit, grole);
end2054:                           printf("provider sent revAcc to user %d\n", mbit);
                                   break
                                :: toU!authzed(id, mbit) ->
                                   goto authzed5
                                :: timeout
                                fi
                             :: toU!revAcc(id, mbit) ->
end2050:                        printf("provider sent revAcc to user %d\n", mbit);
                                break
                             :: toU!termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end2052:                        printf("provider sent termi to user %d\n", mbit);
                                break
                             :: timeout
                             fi
                          :: toPO?terManager(id, abit, 1) ->
                             toU!termi(id, mbit);
end1007:                     printf("provider received termi from manager and sent it to user %d\n", mbit);
                             break
                          :: toU!authzed(id, mbit) ->
                             printf("provider sent authzed authzzing %d\n", mbit);
                             mbit++;
                             goto authzed5
                          :: toU!termi(id, mbit) ->
                             toO!uncontracted(id, abit, grole);
end1006:                     printf("provider received termi authzzing %d\n", mbit);
                             break
                          :: timeout
                          fi
                    :: toPO?accRes(id, abit, 1) ->
                          printf("provider received deny from AC %d\n", abit);
                          if
                          :: toP?revReq(id, mbit) ->
                             mbit++;
end8021:                     toU!termi(id, mbit);
                             break
                          :: toP?termi(id, mbit) ->
end1008:                     printf("provider received termi when received authFail from AC authzNeg1 %d\n", mbit);
                             break
                          :: toU!authzFail(id, mbit) ->
end1009:                     printf("provider sent authz fail authzzing authzNeg1 %d\n", mbit);
                             break
                          :: toU!termi(id, mbit) ->
end1010:                     printf("provider sent authz fail authzzing authzNeg1 %d\n", mbit);
                             break
                          :: timeout
                          fi
                    :: toU!termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end216:                printf("provider sent authzing contracting1 %d\n", mbit);
                       break
                    :: timeout
                    
                od;

authzNeg4: do
           
             
             :: toPO?accRes(id, abit, 0) ->
                abit++;
                printf("provider received agree from AC %d\n", abit);
                if
               :: toP?termi(id, mbit) ->
                  toO!uncontracted(id, abit, grole);
end2000:          printf("provider received termi authzzing %d\n", mbit);
                  break
               :: toPO?terManager(id, abit, 1) ->
                  toU!termi(id, mbit);
end2007:          printf("provider received termi from manager and sent it to user %d\n", mbit);
                  break
               :: toU!authzed(id, mbit) ->
                  printf("provider sent authzed authzzing %d\n", mbit);
                  mbit++;
                  goto authzed5
               :: toU!termi(id, mbit) ->
                  toO!uncontracted(id, abit, grole);
end2001:          printf("provider received termi authzzing %d\n", mbit);
                  break
               :: timeout
               fi
             :: toPO?accRes(id, abit, 1) ->
                printf("provider received deny from AC %d\n", abit);
                if
                :: toP?termi(id, mbit) ->
end2002:           printf("provider received termi when received authFail from AC authzNeg1 %d\n", mbit);
                   break
                :: toU!authzFail(id, mbit) ->
end2003:           printf("provider sent authz fail authzzing authzNeg1 %d\n", mbit);
                   break
                :: toU!termi(id, mbit) ->
end2004:           printf("provider sent authz fail authzzing authzNeg1 %d\n", mbit);
                   break
                :: timeout
                fi
             :: timeout
             
          od;


authzed5:  do
           
              :: toP?revReq(id, mbit) ->
                 printf("provider received revReq authzed5 %d\n", mbit);
                 mbit++;
                 if
                 :: toP?termi(id, mbit) ->
                    toO!uncontracted(id, abit, grole);
end115:             printf("provider received termi authzed5 %d\n", mbit);
                    break
                 :: toPO?terManager(id, abit, 1) ->
                    toU!termi(id, mbit);
end1012:            printf("provider received termi from manager and sent it to user %d\n", mbit);
                    break
                 :: toU!revAcc(id, mbit) ->
end22:              printf("provider sent revAcc authzed5 %d\n", mbit);
                    break
                 :: toU!revRej(id, mbit) ->
                    mbit++;
                    printf("provider sent revRej authzed5 %d\n", mbit);
                    if
                    :: toP?termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end31:                 printf("provider received termi authzed5 %d\n", mbit);
                       break
                    :: toPO?terManager(id, abit, 1) ->
                       toU!termi(id, mbit);
end1013:               printf("provider received termi from manager and sent it to user %d\n", mbit);
                       break
                    :: toU!reject(id, mbit) ->
end23:                 printf("provider sent reject authzed5 %d\n", mbit);
                       break
                    :: toU!accept(id, mbit) ->
                       mbit++;
                       printf("provider sent accept authzed5 %d\n", mbit);
                       if 
                       :: toP?revReq(id, mbit);
                          mbit++;
                          printf("provider received revReq authzed5 %d\n", mbit);
                          if
                          :: toP?termi(id, mbit) ->
                             toO!uncontracted(id, abit, grole);
end26:                       printf("provider received termi authzed5 %d\n", mbit);
                             break
                          :: toPO?terManager(id, abit, 1) ->
                             toU!termi(id, mbit);
end1015:                     printf("provider received termi from manager and sent it to user %d\n", mbit);
                             break
                          :: toU!revAcc(id, mbit) ->
end24:                       printf("provider sent revAcc authzed5 %d\n", mbit);
                             break
                          :: toU!revRej(id, mbit) ->
                             mbit++;
                             printf("provider sent revRej authzed5 %d\n", mbit);
                             if
                             :: toPO?terManager(id, abit, 1) ->
                                toU!termi(id, mbit);
end1016:                        printf("provider received termi from manager and sent it to user %d\n", mbit);
                                break
                             :: toP?accAck(id, mbit) ->
                                toO!contracted(id, abit, grole);
end25:                          printf("provider received accAck authzed5 %d\n", mbit);
                                break
                             :: toP?termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end92:                          printf("provider received termi authzed5 %d\n", mbit);
                                break
                             :: toU!termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end93:                          printf("provider sent accAck authzed5 %d\n", mbit);
                                break
                             :: timeout
                             fi
                          :: toU!termi(id, mbit) ->
                             toO!uncontracted(id, abit, grole);
end27:                       printf("provider sent termi authzed5 %d\n", mbit);
                             break
                          :: timeout
                          fi
                       :: toPO?terManager(id, abit, 1) ->
                          toU!termi(id, mbit);
end1014:                  printf("provider received termi from manager and sent it to user %d\n", mbit);
                          break
                       :: toP?accAck(id, mbit) ->
                          toO!contracted(id, abit, grole);
end28:                    printf("provider received accAck authzed5 %d\n", mbit);
                          break
                       :: toP?termi(id, mbit) ->
                          toO!uncontracted(id, abit, grole);
end29:                    printf("provider received termi authzed5 %d\n", mbit);
                          break
                       :: toU!termi(id, mbit) ->
                          toO!uncontracted(id, abit, grole);
end30:                    printf("provider sent termi authzed5 %d\n", mbit);
                          break
                       :: timeout
                       fi
                    :: toU!termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end32:                 printf("provider sent termi authzed5 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toU!termi(id, mbit) ->
                    toO!uncontracted(id, abit, grole);
end316:             printf("provider sent termi authzed5 %d\n", mbit);
                    break
                 :: timeout
                 fi
              :: toPO?terManager(id, abit, 1) ->
                 toU!termi(id, mbit);
end1011:         printf("provider received termi from manager and sent it to user %d\n", mbit);
                 break
              :: toP?termi(id, mbit) ->
                 toO!uncontracted(id, abit, grole);
end41:           printf("provider received termi authzed5 %d\n", mbit);
                 break
              :: toU!reject(id, mbit) ->
end33:           printf("provider sent reject after deny revoke authozed authzed5 %d\n", mbit);
                 break
              :: toU!accept(id, mbit) ->
                 printf("provider sent accept authzed5 %d\n", mbit);
                 mbit++;
                 if 
                 :: toP?revReq(id, mbit);
                    printf("provider received revReq authzed5 %d\n", mbit);
                    mbit++;
                    if
                    :: toP?termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end36:                 printf("provider received termi authzed5 %d\n", mbit);
                       break
                    :: toPO?terManager(id, abit, 1) ->
                       toU!termi(id, mbit);
end2009:               printf("provider received termi from manager and sent it to user %d\n", mbit);
                       break
                    :: toU!revAcc(id, mbit) ->
end34:                 printf("provider sent recAcc authzed5 %d\n", mbit);
                       break
                    :: toU!revRej(id, mbit) ->
                       printf("provider sent revRej authzed5 %d\n", mbit);
                       mbit++;
                       if
                             :: toP?accAck(id, mbit) ->
                                toO!contracted(id, abit, grole);
end35:                          printf("provider received accAck authzed5 %d\n", mbit);
                                break
                             :: toPO?terManager(id, abit, 1) ->
                                toU!termi(id, mbit);
end2010:                        printf("provider received termi from manager and sent it to user %d\n", mbit);
                                break
                             :: toP?termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end94:                          printf("provider received termi authzed5 %d\n", mbit);
                                break
                             :: toU!termi(id, mbit) ->
                                toO!uncontracted(id, abit, grole);
end95:                          printf("provider sent termi authzed5 %d\n", mbit);
                                break
                             :: timeout
                             fi
                    :: toU!termi(id, mbit) ->
                       toO!uncontracted(id, abit, grole);
end37:                 printf("provider received termi authzed5 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toPO?terManager(id, abit, 1) ->
                    toU!termi(id, mbit);
end2019:            printf("provider received termi from manager and sent it to user %d\n", mbit);
                    break
                 :: toP?accAck(id, mbit) ->
                    toO!contracted(id, abit, grole);
end38:              printf("provider received accAck authzed5 %d\n", mbit);
                    break
                 :: toP?termi(id, mbit) ->
                    toO!uncontracted(id, abit, grole);
end39:              printf("provider received termi authzed5 %d\n", mbit);
                    break
                 :: toU!termi(id, mbit) ->
                    toO!uncontracted(id, abit, grole);
end40:              printf("provider received termi authzed5 %d\n", mbit);
                    break
                 :: timeout
                 fi
              :: toU!termi(id, mbit) ->
                 toO!uncontracted(id, abit, grole);
end42:           printf("provider received termi authzed5 %d\n", mbit);
                 break
              :: timeout
              
           od; 


contracting3:  do
               
                 :: toP?termi(id, mbit) ->
end52:              printf("provider received termi contracting3 %d\n", mbit);
                    break
                 :: toU!authzing(id, mbit) ->
                    printf("provider sent authzing contracing3 %d\n", mbit);
                    mbit++;
                    if
                    :: toP?revReq(id, mbit) ->
                       mbit++;
end7001:               toU!termi(id, mbit);
                       break
                    :: toP?termi(id, mbit) ->
end7002:               printf("provider received termi contracting1 %d\n", mbit);
                       break
                    :: toO!accReq(id, abit, grole) ->
                       printf("provider sent accReq contracting1 %d\n", mbit);
                       abit++;
                       goto accessNeg
                    :: toU!termi(id, mbit) ->
end7003:               printf("provider sent termi contracting1 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toU!termi(id, mbit) ->
end53:              printf("provider received termi contracting3 %d\n", mbit);
                    break
                 :: timeout
                 
              od;

contracting2: do
              
                 :: toP?revReq(id, mbit) ->
                    printf("provider received revoke request contracting2 %d\n", mbit);
                    mbit++;
                    if
                    :: toU!revRej(id, mbit) ->
                       printf("provider deny revoke request contracting2 %d\n", mbit);
                       mbit++;
                       if
                       :: toP?termi(id, mbit) ->
end70:                    printf("provider received termi contracting2 %d\n", mbit);
                          break
                       :: toU!authzing(id, mbit) ->
                          printf("provider sent authzing contracting2 %d\n", mbit);
                          mbit++;
                          if
                          :: toP?revReq(id, mbit) ->
                             mbit++;
end7004:                     toU!termi(id, mbit);
                             break
                          :: toP?termi(id, mbit) ->
end7005:                     printf("provider received termi contracting1 %d\n", mbit);
                             break
                          :: toO!accReq(id, abit, grole) ->
                             printf("provider sent accReq contracting1 %d\n", mbit);
                             abit++;
                             goto accessNeg
                          :: toU!termi(id, mbit) ->
end7006:                     printf("provider sent termi contracting1 %d\n", mbit);
                             break
                          :: timeout
                          fi                       
                       :: toU!reject(id, mbit) ->
end69:                    printf("provider rejected request contracting2 %d\n", mbit);
                          break
                       :: toU!termi(id, mbit) ->
end71:                    printf("provider received termi contracting2 %d\n", mbit);
                          break
                       :: timeout
                       fi
                    :: toP?termi(id, mbit) ->
end8000:               printf("provider received termi contracting2 %d\n", mbit);
                       break
                    :: toU!termi(id, mbit) ->
end8001:               printf("provider sent termi contracting2 %d\n", mbit);
                       break
                    :: toU!revAcc(id, mbit) ->
end61:                 printf("provider accepted revoke request contracting2 %d\n", mbit);
                       break
                    :: timeout
                    fi
                 :: toP?termi(id, mbit) ->
end80:              printf("provider received termi contracting2 %d\n", mbit);
                    break
                 :: toU!authzing(id, mbit) ->
                    printf("provider sent authzing contracting2 %d\n", mbit);
                    mbit++;
                    if
                    :: toP?revReq(id, mbit) ->
                       mbit++;
end7009:               toU!termi(id, mbit);
                       break
                    :: toP?termi(id, mbit) ->
end7010:               printf("provider received termi contracting1 %d\n", mbit);
                       break
                    :: toO!accReq(id, abit, grole) ->
                       printf("provider sent accReq contracting1 %d\n", mbit);
                       abit++;
                       goto accessNeg
                    :: toU!termi(id, mbit) ->
end7012:               printf("provider sent termi contracting1 %d\n", mbit);
                       break
                    :: timeout
                    fi                  
                 :: toU!termi(id, mbit) ->
end81:              printf("provider received termi contracting2 %d\n", mbit);
                    break
                 :: timeout
                 
              od;

}

init{
  atomic{
    run User();
    run AS();
    run Pro();
}
}
