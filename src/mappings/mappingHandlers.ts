import { PrismaClient } from '@prisma/client';
import { IBlockResponse } from '../types/horoscope-response/block_response';
import { ITransactionResponse } from '../types/horoscope-response/transaction_response';
import { IMessageResponse } from '../types/horoscope-response/message_response';
import { IEventResponse } from '../types/horoscope-response/event_response';
import { MESSAGE_TYPE } from '../shared/constants/common';

const prisma = new PrismaClient();

export async function handleBlocks(
  blockData: IBlockResponse,
  trx: any,
): Promise<void> { }

export async function handleTransactions(
  txDatas: ITransactionResponse,
  trx: any,
): Promise<void> { }

export async function handleMessages(
  msg: IMessageResponse,
  trx: any,
): Promise<void> {
  console.log('catched message:');
  console.log(msg);
  if (msg.transaction?.code != 0) {
    return;
  }

  switch (msg.type) {
    case MESSAGE_TYPE.MSG_ACTIVE_ACCOUNT: {
      const sender = msg.sender;
      const pubkey = msg.content.public_key.value;
      const contract_info = JSON.stringify(msg.content);
      const resultInsert = await prisma.smart_wallet.create({
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        data: { address: sender, pubkey, contract_info },
      });
      console.log('result insert: ', resultInsert.id);
      break;
    }
    case MESSAGE_TYPE.MSG_EXECUTE_CONTRACT: {
      const exeMsg = JSON.parse(msg.content.msg);
      //TO DO: Check type register plugin. exeMsg.register_plugin.plugin_address

      const configMsg = JSON.parse(exeMsg.register_plugin.config);
      const wallet_address = configMsg.smart_account_address;
      const recover_wallet = configMsg.recover_address;

      const resultInsert = await prisma.recovery_account.create({
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        data: { wallet_address, recover_wallet },
      });
      console.log('result insert: ', resultInsert.id);
      break;
    }
    default: { 
      console.log('default');
    }
  }

}

export async function handleEvents(
  event: IEventResponse,
  trx: any,
): Promise<void> { }
