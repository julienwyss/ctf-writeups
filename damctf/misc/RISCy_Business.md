# RISCy Business

| Titel          | Kategorie | flag | Difficulty |
| :---        |    :----   |:--- |  :--- |
| RISCy Business | misc  | dam{Fr33R705_15_C001_on_the_esp32c6} | unknown |

## Description
Little Timmy has been experimenting with home automation! He has some ESP32-C6 Zigbee devices and put an important flag in the firmware. He has since lost the flag and is having a hard time finding it in the source, can you get it for him?
## Attachments
espotaclient.elf

## Solution
The file is a:
``` bash
esp_ota_client.elf: ELF 32-bit LSB executable, UCB RISC-V, RVC, soft-float ABI, version 1 (SYSV), statically linked, with debug_info, not stripped
```
So i opened it in Ghidra and searched for the app entry and found it in the `app_main`function.

``` c

void app_main(void)

{
  uint32_t uVar1;
  int iVar2;
  undefined1 auStack_70 [104];
  
  gp = 0x4080fb94;
  zigbee_event_group_flag = xEventGroupCreate();
  xStringMutex = xQueueCreateMutex('\x01');
  if (xStringMutex == (QueueHandle_t)0x0) {
    uVar1 = esp_log_timestamp();
    esp_log((esp_log_config_t)0x1,s_ESP_OTA_CLIENT_42063488,
            s_E_(%lu)_%s:_Error_with_string_mu_420640cc,uVar1,s_ESP_OTA_CLIENT_42063488);
  }
  uVar1 = esp_log_timestamp();
  esp_log((esp_log_config_t)0x2,s_ESP_OTA_CLIENT_42063488,
          s_W_(%lu)_%s:_Modified_ESP_Zigbee_O_420640f4,uVar1,s_ESP_OTA_CLIENT_42063488);
  memset(auStack_70,0,0x60);
  iVar2 = nvs_flash_init();
  if (iVar2 == 0) {
    iVar2 = esp_zb_platform_config(auStack_70);
    if (iVar2 == 0) {
      xTaskCreatePinnedToCore
                (build_flag_task,s_build_flag_task_42064164,0x800,(void *)0x0,1,(TaskHandle_t *)0x0,
                 0x7fffffff);
      xTaskCreatePinnedToCore
                (esp_zb_task,s_Zigbee_main_42064174,0x1000,(void *)0x0,5,(TaskHandle_t *)0x0,
                 0x7fffffff);
      return;
    }
                    /* WARNING: Subroutine does not return */
    _esp_error_check_failed
              (iVar2,s_./main/esp_ota_client.c_42063b50,0x18e,__func__.9,
               s_esp_zb_platform_config(&config)_42064144);
  }
                    /* WARNING: Subroutine does not return */
  _esp_error_check_failed
            (iVar2,s_./main/esp_ota_client.c_42063b50,0x18d,__func__.9,s_nvs_flash_init()_42064130);
}
```

What was interesting was the `build_flag_task` function. I opened it and found this:
``` c
void build_flag_task(void)

{
  undefined1 uVar1;
  undefined1 uVar2;
  undefined1 uVar3;
  undefined1 uVar4;
  char cVar5;
  char cVar6;
  char cVar7;
  char cVar8;
  char cVar9;
  char cVar10;
  char cVar11;
  char cVar12;
  undefined1 uVar13;
  undefined1 uVar14;
  undefined1 uVar15;
  undefined1 *__ptr;
  BaseType_t BVar16;
  int iVar17;
  char *pcVar18;
  undefined1 *puVar19;
  
  gp = 0x4080fb94;
  esp_log_timestamp();
  esp_log((esp_log_config_t)0x3,s_ESP_OTA_CLIENT_42063488,
          s_I_(%lu)_%s:_Waiting_for_Zigbee_n_42063708);
  xEventGroupWaitBits(zigbee_event_group_flag,1,1,1,0xffffffff);
  __ptr = (undefined1 *)malloc(0x26);
  if (__ptr == (undefined1 *)0x0) {
    puts(s_Memory_allocation_failed_42063740);
    vTaskDelete((TaskHandle_t)0x0);
  }
  BVar16 = xQueueSemaphoreTake(xStringMutex,0xffffffff);
  if (BVar16 != 0) {
    printf(s_Task_2_received:_%s_4206375c,sharedString);
    xQueueGenericSend(xStringMutex,(void *)0x0,0,0);
    uVar4 = DAT_42063778;
    uVar3 = DAT_42063777;
    uVar2 = DAT_42063776;
    uVar1 = DAT_42063775;
    *__ptr = DAT_42063774;
    __ptr[1] = uVar1;
    __ptr[2] = uVar2;
    __ptr[3] = uVar3;
    __ptr[4] = uVar4;
    strcat(__ptr,sharedString);
    iVar17 = strlen(__ptr);
    cVar12 = s__on_the__4206377c[8];
    cVar11 = s__on_the__4206377c[7];
    cVar10 = s__on_the__4206377c[6];
    cVar9 = s__on_the__4206377c[5];
    cVar8 = s__on_the__4206377c[4];
    cVar7 = s__on_the__4206377c[3];
    cVar6 = s__on_the__4206377c[2];
    cVar5 = s__on_the__4206377c[1];
    pcVar18 = __ptr + iVar17;
    *pcVar18 = s__on_the__4206377c[0];
    pcVar18[1] = cVar5;
    pcVar18[2] = cVar6;
    pcVar18[3] = cVar7;
    pcVar18[4] = cVar8;
    pcVar18[5] = cVar9;
    pcVar18[6] = cVar10;
    pcVar18[7] = cVar11;
    pcVar18[8] = cVar12;
    iVar17 = strlen(__ptr);
    uVar15 = DAT_4206378f;
    uVar14 = DAT_4206378e;
    uVar13 = DAT_4206378d;
    uVar4 = DAT_4206378c;
    uVar3 = DAT_4206378b;
    uVar2 = DAT_4206378a;
    uVar1 = DAT_42063789;
    puVar19 = __ptr + iVar17;
    *puVar19 = DAT_42063788;
    puVar19[1] = uVar1;
    puVar19[2] = uVar2;
    puVar19[3] = uVar3;
    puVar19[4] = uVar4;
    puVar19[5] = uVar13;
    puVar19[6] = uVar14;
    puVar19[7] = uVar15;
    iVar17 = strlen(__ptr);
    __ptr[iVar17] = 0x7d;
    (__ptr + iVar17)[1] = 0;
  }
  esp_log_timestamp();
  esp_log((esp_log_config_t)0x3,s_ESP_OTA_CLIENT_42063488,s_I_(%lu)_%s:_Flag:_%s_42063790);
  free(__ptr);
  vTaskDelete((TaskHandle_t)0x0);
  return;
}
```

So now we can start building the flag. First it starts with the:
``` c
    uVar4 = DAT_42063778;
    uVar3 = DAT_42063777;
    uVar2 = DAT_42063776;
    uVar1 = DAT_42063775;
    *__ptr = DAT_42063774;
    __ptr[1] = uVar1;
    __ptr[2] = uVar2;
    __ptr[3] = uVar3;
    __ptr[4] = uVar4;
```
I then checked the values of the variables and they are:
``` hex
64 61 6d 7b
```
This then translates to: `dam{`

Then we have the `sharedString` wich is not as straight forward as the first part. I checked the value of `sharedString` and it is just question marks inside of ghidra. I then started searching for the sharedString variable in other methods and found it in the `esp_zb_app_signal_handler` function:
``` c
    sharedString[0] = (char)DAT_42064048;
    sharedString[1] = DAT_42064048._1_1_;
    sharedString[2] = DAT_42064048._2_1_;
    sharedString[3] = DAT_42064048._3_1_;
    sharedString[4] = (char)DAT_4206404c;
    sharedString[5] = DAT_4206404c._1_1_;
    sharedString[6] = DAT_4206404c._2_1_;
    sharedString[7] = DAT_4206404c._3_1_;
    sharedString[8] = (char)DAT_42064050;
    sharedString[9] = DAT_42064050._1_1_;
    sharedString[10] = DAT_42064050._2_1_;
    sharedString[0xb] = DAT_42064050._3_1_;
    sharedString[0xc] = (char)DAT_42064054;
    sharedString[0xd] = DAT_42064054._1_1_;
    sharedString[0xe] = DAT_42064054._2_1_;
    sharedString[0xf] = DAT_42064054._3_1_;
    sharedString[0x10] = DAT_42064058;
    xQueueGenericSend(xStringMutex,(void *)0x0,0,0);
```
I then checked the values of the variables and they are:
``` hex
46 72 33 33 52 37 30 35 5f 31 35 5f 43 30 30 31 00
 F  r  3  3  R  7  0  5  _  1  5  _  C  0  0  1  (null terminator)
```
So `sharedString = "Fr33R705_15_C001"`

Then back into the `build_flag_task` function we have:
``` c
    cVar12 = s__on_the__4206377c[8];
    cVar11 = s__on_the__4206377c[7];
    cVar10 = s__on_the__4206377c[6];
    cVar9 = s__on_the__4206377c[5];
    cVar8 = s__on_the__4206377c[4];
    cVar7 = s__on_the__4206377c[3];
    cVar6 = s__on_the__4206377c[2];
    cVar5 = s__on_the__4206377c[1];
```

This containes the string `_on_the_` and is just a string that is added to the flag. 

We then have:
``` c
    *puVar19 = DAT_42063788;  // 'e'
    puVar19[1] = DAT_42063789; // 's'
    puVar19[2] = DAT_4206378a; // 'p'
    puVar19[3] = DAT_4206378b; // '3'
    puVar19[4] = DAT_4206378c; // '2'
    puVar19[5] = DAT_4206378d; // 'c'
    puVar19[6] = DAT_4206378e; // '6'
    puVar19[7] = DAT_4206378f; // null terminator
```

This is just the string `esp32c6` and is added to the flag.

Then in the very end we have:
``` c
    __ptr[iVar17] = 0x7d; // }
```
This is just the closing bracket of the flag.

So all of these parts combined we get the flag:
``` c
dam{Fr33R705_15_C001_on_the_esp32c6}
```