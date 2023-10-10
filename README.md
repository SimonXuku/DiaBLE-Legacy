<p align="center"><img src="./DiaBLE/Assets.xcassets/AppIcon.appiconset/Icon.png" width="25%" /></p>


Since the latest **FreeStyle Libre glucose sensors** are **B**luetooth **L**ow **E**nergy devices and the **Dexcom ONE/G7** are availaBLE for private purchase at affordaBLE prices at last, I am trying to leverage their capabilities to implement something new compared to the traditional apps:

* a universal **SwiftUI** application for iPhone, iPad and Mac Catalyst;
* an **independent Apple Watch app** connecting directly via Bluetooth;
* scanning the Libre directly via **NFC** and exploring its internals;
* using both online servers and offline methods for calibrating just like the **temperature-based** vendor algorithm;
* showing for comparison the **HealthKit** and **Nightscout** data shared with other apps;
* varying the **reading interval** instead of the usual 5-minute one;
* a detailed **log** to check the traffic from/to the BLE devices and remote servers.

To build the project you have to duplicate the file _DiaBLE.xcconfig_, rename the copy to _DiaBLEOverride.xcconfig_ (the missing reference displayed by Xcode in red should then point to it) and edit it by deleting the last line `#include?... ` and replacing `##TEAM_ID##` with your Apple Team ID so that the first line should read for example `DEVELOPMENT_TEAM = Z25SC9UDC8`.

The NFC capabilities require a paid ADC annual membership. The simplest way to get invited to the internal TestFlight builds is to sponsor me $-)

If you own an iPad you can download the [zipped archive](https://github.com/gui-dos/DiaBLE-Legacy/archive/refs/heads/main.zip) of this repository and tap _DiaBLE Playground.swiftpm_: DiaBLE was born in fact as a single script for the iPad Swift Playgrounds to test the internal workings of the several trouBLEsome BLE accessories I bought, mainly the **Bubble** and the **MiaoMiao**. I upgraded it to the version 4.1 of the Playgrounds which still runs under iOS 15 and macOS Monterey but I cannot afford to support actively such transmitters and the LibreOOPWeb glucose.space server anymore.

Currently I am targeting only the latest betas of Xcode and iOS and focusing on the new Libre 3 and Dexcom G7. The new _async / await_ and _actors_ introduced in Swift 5.5 and iOS 15 probably would require a total rewrite of DiaBLE's foundations, as well as the enhanced *Gen2* protocols already adopted by the Libre 2 Sense/US/CA/AU which haven't been reversed yet.

Still too early to decide the final design (but I really like already the evil logo 😈), here there are some recent screenshots I tweeted or posted in the comments:

<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/260526410-76e95c8c-61e4-4a46-8bf2-5dd0cc53ba31.png" width="90%"></p>
<h4 align ="center">Nice technical post mentioning me 😎: <a href="https://frdmtoplay.com/freeing-glucose-data-from-the-freestyle-libre-3/">"Liberating glucose data from the Freestyle Libre 3"</a></h4>
<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/201089112-7c15993c-9574-43cf-8371-3821cc854903.png" width="33.3%"></p>
<h4 align ="center">Companion Comparison</h4>
<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/181923772-f9b35a52-1ff7-47a4-ba7a-445233cb8e25.PNG" width="25%" align="middle" /> &nbsp; &nbsp; <img src="https://user-images.githubusercontent.com/7220550/181924382-8b325de0-e457-4dbf-a3fc-ea87e85fd231.PNG" width="25%" align="middle" /></p>
<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/184549737-6e931282-9817-47be-aaf8-1f94ad6be8b9.png" width="33.3%" align="middle" /> &nbsp; &nbsp; <img src="https://user-images.githubusercontent.com/7220550/184549763-4d984707-d58f-4f80-a2b6-374193a10c73.png" width="16.7%" align="middle" /></p>
<h4 align ="center">Libre 3 Details</h4>
<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/200558485-ca29b560-0697-4ab5-ac1c-6aa3dd8b5422.png" width="33.3%" /> &nbsp; &nbsp; <img src="https://user-images.githubusercontent.com/7220550/200558284-54e69a55-a790-41af-84a9-293c8e12574d.png" width="33.3%" /></p>
<h4 align ="center">Libre 1 Brownout</h4>
<br><br>
<p align="center"><img src="https://user-images.githubusercontent.com/7220550/205249892-05eb4d83-9d10-4407-9100-fe4971a8ef3e.PNG" width="33.3%" /> &nbsp; &nbsp; <img src="https://user-images.githubusercontent.com/7220550/205249921-69aa3e13-1dc6-4332-bd22-4797d36af9c4.PNG" width="33.3%" /></p>
<h4 align ="center">Welcome Gluroo, Heroku adieu!</h4>
<br><br>

Please refer to the [**TODOs**](https://github.com/gui-dos/DiaBLE/blob/main/TODO.md) list for the up-to-date status of all the current limitations and known bugs of this **prototype**.

**Warnings:**
  * the temperature-based calibration algorithm has been derived from the old LibreLink 2.3: it is known that the Vendor improves its algorithms at every new release, smoothing the historical values and projecting the trend ones into the future to compensate the interstitial delay but these further stages aren't understood yet; I never was convinced by the simple linear regression models that others apply on finger pricks;
  * activating the BLE streaming of data on a Libre 2 will break other apps' pairings and you will have to reinstall them to get their alarms back again; in Test mode it is possiBLE however to sniff the incoming data of multiple apps running side-by-side by just activating the notifications on the known BLE characteristics: the same technique is used to analyze the Libre 3 incoming traffic since the Core Bluetooth connections are reference-counted;
  * connecting directly to a Libre 2/3 from an Apple Watch is currently just a proof of concept that it is technically possiBLE: keeping the connection in the background will require additional work and AFAIK nobody else is capaBLE of doing the job... :-P
  
The Shell in the Console allows opening both encrypted and decrypted _trident.realm_ files from a backup of the Libre 3 app data (the Container folder extracted for example by using iMazing): see the nice technical post (mentioning me 😎) ["Liberating glucose data from the Freestyle Libre 3"](https://frdmtoplay.com/freeing-glucose-data-from-the-freestyle-libre-3/) (a rooted Android Virtual Machine like the default Google APIs System Image in Android Studio is required to unwrap the Realm encryption key).

### DON'T TRUST THE GROWING NUMBER OF "METABOLIC HEALTH" STARTUPS WHICH RESELL LIBRE SENSORS AND REUSE MY NAIVE NFC CODE: IT IS A SCANDAL WHICH WOULD DESERVE A CLASS ACTION THAT THE VENDOR PROMOTES SUCH PSEUDOSCIENTIFIC FRAUDS AND RESELLS TO HYPOCHONDRIACS "BIOSENSORS" THAT ARE JUST A REBRAND OF THE SECURED GEN2 MODEL BECAUSE THEY COULDN'T PROMOTE IT AS A CGM DEVICE IN 2021 GIVEN THE LEGAL BATTLE WITH DEXCOM.

***Note***: the exploitation which allows to reset and reactivate a Libre 1 is well known to the Vendor and was unveiled already during [BlackAlps 2019](https://www.youtube.com/watch?v=Y9vtGmxh1IQ) and in [PoC||GTFO 0x20](https://archive.org/stream/pocorgtfo20#page/n6/mode/1up).

---
***Credits***: [@bubbledevteam](https://github.com/bubbledevteam), [@captainbeeheart](https://github.com/captainbeeheart), [@creepymonster](https://github.com/creepymonster), [@cryptax](https://github.com/cryptax), [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift), [@dabear](https://github.com/dabear), [@DecentWoodpecker67](https://github.com/DecentWoodpecker67), [@ivalkou](https://github.com/ivalkou), [Jaap Korthals Altes](https://github.com/j-kaltes), [@keencave](https://github.com/keencave), [LibreMonitor](https://github.com/UPetersen/LibreMonitor/tree/Swift4), [Loop](https://github.com/LoopKit/Loop), [Marek Macner](https://github.com/MarekM60), [@monder](https://github.com/monder), [Nightguard]( https://github.com/nightscout/nightguard), [Nightscout LibreLink Up Uploader](https://github.com/timoschlueter/nightscout-librelink-up), [@travisgoodspeed](https://github.com/travisgoodspeed), [WoofWoof](https://github.com/gshaviv/ninety-two), [xDrip](https://github.com/Faifly/xDrip), [xDrip+](https://github.com/NightscoutFoundation/xDrip), [xDrip4iO5](https://github.com/JohanDegraeve/xdripswift).

###### ***Disclaimer: the decrypting keys I am publishing are not related to user accounts and can be dumped from the sensor memory by using DiaBLE itself. The online servers I am using probably are tracking your personal data but all the traffic sent/received by DiaBLE is clearly shown in its logs. The reverse-engineered code I am copying&pasting has been retrieved from other GitHub repos or reproduced simply by using open-source tools like Ghidra and `jadx-gui`.***
