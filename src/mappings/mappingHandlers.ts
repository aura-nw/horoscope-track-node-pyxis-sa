import { PrismaClient } from '@prisma/client';
import { IBlockResponse } from '../types/horoscope-response/block_response';
import { ITransactionResponse } from '../types/horoscope-response/transaction_response';
import { IMessageResponse } from '../types/horoscope-response/message_response';
import { IEventResponse } from '../types/horoscope-response/event_response';
import { MESSAGE_TYPE } from '../shared/constants/common';
// import { CosmWasmClient } from '@cosmjs/cosmwasm-stargate';
// import * as appConfig from '../shared/configs/configuration';

const prisma = new PrismaClient();
// const config = appConfig.default();

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
  if (msg.transaction?.code != 0) {
    return;
  }
  console.log('catched message:');
  console.log(msg);
  switch (msg.type) {
    case MESSAGE_TYPE.MSG_ACTIVE_ACCOUNT: {
      const sender = msg.sender;
      const pubkey = msg.content.public_key.value;
      const contract_info = JSON.stringify(msg.content);
      const resultInsert = await prisma.smart_wallet.createMany({
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        data: [{ address: sender, pubkey, contract_info }], skipDuplicates: true,
      });
      console.log('result insert smart wallet: ', resultInsert);
      break;
    }
    case MESSAGE_TYPE.MSG_EXECUTE_CONTRACT: {
      const exeMsg = JSON.parse(msg.content.msg);
      const { allow_plugin, register_plugin } = exeMsg;
      if (allow_plugin) {
        const { plugin_info } = allow_plugin;
        const { name, plugin_type, version, code_id, address, enabled } = plugin_info;

        const resultInsertPlugin = await prisma.plugins.createMany({
          // eslint-disable-next-line @typescript-eslint/ban-ts-comment
          // @ts-ignore
          data: [{ name, plugin_type, version, code_id, address, enabled }], skipDuplicates: true,
        });

        console.log('resultInsertPlugin: ', resultInsertPlugin);
        break;
      }
      if (register_plugin) {
        const { plugin_address } = register_plugin;
        const configMsg = JSON.parse(register_plugin.config);
        const { smart_account_address, recover_address } = configMsg;

        //TO DO: Check type register plugin. exeMsg.register_plugin.plugin_address
        // Connect to network
        // const client = await CosmWasmClient.connect(config.network.rpcUrl);

        // //Get Plugin contract information
        // const queryMsg = { plugin_info: { address: plugin_address } };
        // const queryResult = await client.queryContractSmart(
        //   config.network.pluginManagerAddress,
        //   queryMsg,
        // );
        // console.log('queryResult: ', queryResult);

        //Check at DB
        const queryResult = await prisma.plugins.findFirst({ where: { address: plugin_address } })
        if (queryResult && queryResult.plugin_type == 'recovery') {

          const resultInsertPluginRegistration = await prisma.plugins_registration.createMany({
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-ignore
            data: [{ smart_account_address, plugin_address }], skipDuplicates: true,
          });

          const resultInsertRecoveryAccount = await prisma.recovery_account.createMany({
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-ignore
            data: [{ wallet_address: smart_account_address, recover_wallet: recover_address }], skipDuplicates: true,
          });
          console.log('resultInsertPluginRegistration: ', resultInsertPluginRegistration);
          console.log('resultInsertRecoveryAccount: ', resultInsertRecoveryAccount);
          break;
        }
      }

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
