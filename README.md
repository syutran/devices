# 两级机构电子设备登记与管理

This README would normally document whatever steps are necessary to get the
application up and running.

### 开发环境:

* Ruby on rails (ruby 2.1 and rails 3.2)

* database mysql

* bootstarp 4.0

### 实现功能

#### 主管机构

* 电子设备的入库（购置新设备）

* 电子设备的分发

电子设备分发后，设备处于分发状态，待分支机构点取领用后，状态转至分支机构。

* 电子设备的收回待用

分支机构上交的设备，转为待用或待报废。

* 电子设备转报废

#### 分支机构

* 领取设备

* 登记设备的部分信息和使用人

* 设备转上交

设备转上交后，只是状态变为待收回，待上级机构确认收回后，设备从本机构中删除。
