-- Create table
create table XXL_JOB_GROUP
(
    id           NUMBER(11) not null,
    app_name     NVARCHAR2(64) not null,
    title        NVARCHAR2(12) not null,
    address_type NUMBER(4) default 0 not null,
    address_list NVARCHAR2(512)
);
-- Add comments to the columns
comment on column XXL_JOB_GROUP.app_name
    is '执行器AppName';
comment on column XXL_JOB_GROUP.title
    is '执行器名称';
comment on column XXL_JOB_GROUP.address_type
    is '执行器地址类型：0=自动注册、1=手动录入';
comment on column XXL_JOB_GROUP.address_list
    is '执行器地址列表，多地址逗号分隔';
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_GROUP
    add primary key (ID);
--------------------------
-- Create table
create table XXL_JOB_INFO
(
    id                        NUMBER(11) not null,
    job_group                 NUMBER(11) not null,
    job_cron                  NVARCHAR2(128) not null,
    job_desc                  NVARCHAR2(255) not null,
    add_time                  DATE,
    update_time               DATE,
    author                    NVARCHAR2(64),
    alarm_email               NVARCHAR2(255),
    executor_route_strategy   NVARCHAR2(50),
    executor_handler          NVARCHAR2(255),
    executor_param            NVARCHAR2(512),
    executor_block_strategy   NVARCHAR2(50),
    executor_timeout          NUMBER(11) default 0 not null,
    executor_fail_retry_count NUMBER(11) default 0 not null,
    glue_type                 NVARCHAR2(50) not null,
    glue_source               NCLOB,
    glue_remark               NVARCHAR2(128),
    glue_updatetime           DATE,
    child_jobid               NVARCHAR2(255),
    trigger_status            NUMBER(4) default 0 not null,
    trigger_last_time         NUMBER(20) default 0 not null,
    trigger_next_time         NUMBER(20) default 0 not null
);
-- Add comments to the columns
comment on column XXL_JOB_INFO.job_group
    is '执行器主键ID';
comment on column XXL_JOB_INFO.job_cron
    is '任务执行CRON';
comment on column XXL_JOB_INFO.author
    is '作者';
comment on column XXL_JOB_INFO.alarm_email
    is '报警邮件';
comment on column XXL_JOB_INFO.executor_route_strategy
    is '执行器路由策略';
comment on column XXL_JOB_INFO.executor_handler
    is '执行器任务handler';
comment on column XXL_JOB_INFO.executor_param
    is '执行器任务参数';
comment on column XXL_JOB_INFO.executor_block_strategy
    is '阻塞处理策略';
comment on column XXL_JOB_INFO.executor_timeout
    is '任务执行超时时间，单位秒';
comment on column XXL_JOB_INFO.executor_fail_retry_count
    is '失败重试次数';
comment on column XXL_JOB_INFO.glue_type
    is 'GLUE类型';
comment on column XXL_JOB_INFO.glue_source
    is 'GLUE源代码';
comment on column XXL_JOB_INFO.glue_remark
    is 'GLUE备注';
comment on column XXL_JOB_INFO.glue_updatetime
    is 'GLUE更新时间';
comment on column XXL_JOB_INFO.child_jobid
    is '子任务ID，多个逗号分隔';
comment on column XXL_JOB_INFO.trigger_status
    is '调度状态：0-停止，1-运行';
comment on column XXL_JOB_INFO.trigger_last_time
    is '上次调度时间';
comment on column XXL_JOB_INFO.trigger_next_time
    is '下次调度时间';
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_INFO
    add primary key (ID)
    using index;
-----------------------
-- Create table
create table XXL_JOB_LOCK
(
    lock_name NVARCHAR2(50) not null
);
-- Add comments to the columns
comment on column XXL_JOB_LOCK.lock_name
    is '锁名称';
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_LOCK
    add primary key (LOCK_NAME)
    using index;
------------------------
-- Create table
create table XXL_JOB_LOG
(
    id                        NUMBER(20) not null,
    job_group                 NUMBER(11) not null,
    job_id                    NUMBER(11) not null,
    executor_address          NVARCHAR2(255),
    executor_handler          NVARCHAR2(255),
    executor_param            NVARCHAR2(512),
    executor_sharding_param   NVARCHAR2(20),
    executor_fail_retry_count NUMBER(11) default 0 not null,
    trigger_time              DATE,
    trigger_code              NUMBER(11) not null,
    trigger_msg               NCLOB,
    handle_time               DATE,
    handle_code               NUMBER(11) not null,
    handle_msg                NCLOB,
    alarm_status              NUMBER(4) default 0 not null
);
-- Add comments to the columns
comment on column XXL_JOB_LOG.job_group
    is '执行器主键ID';
comment on column XXL_JOB_LOG.job_id
    is '任务，主键ID';
comment on column XXL_JOB_LOG.executor_address
    is '执行器地址，本次执行的地址';
comment on column XXL_JOB_LOG.executor_handler
    is '执行器任务handler';
comment on column XXL_JOB_LOG.executor_param
    is '执行器任务参数';
comment on column XXL_JOB_LOG.executor_sharding_param
    is '执行器任务分片参数，格式如 1/2';
comment on column XXL_JOB_LOG.executor_fail_retry_count
    is '失败重试次数';
comment on column XXL_JOB_LOG.trigger_time
    is '调度-时间';
comment on column XXL_JOB_LOG.trigger_code
    is '调度-结果';
comment on column XXL_JOB_LOG.trigger_msg
    is '调度-日志';
comment on column XXL_JOB_LOG.handle_time
    is '执行-时间';
comment on column XXL_JOB_LOG.handle_code
    is '执行-状态';
comment on column XXL_JOB_LOG.handle_msg
    is '执行-日志';
comment on column XXL_JOB_LOG.alarm_status
    is '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';
-- Create/Recreate indexes
create index I_HANDLE_CODE on XXL_JOB_LOG (HANDLE_CODE);
create index I_TRIGGER_TIME on XXL_JOB_LOG (TRIGGER_TIME);
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_LOG
    add primary key (ID)
    using index;
-----------------------------------------
-- Create table
create table XXL_JOB_LOGGLUE
(
    id          NUMBER(11) not null,
    job_id      NUMBER(11) not null,
    glue_type   NVARCHAR2(50),
    glue_source NCLOB,
    glue_remark NVARCHAR2(128) not null,
    add_time    DATE,
    update_time DATE
);
-- Add comments to the columns
comment on column XXL_JOB_LOGGLUE.job_id
    is '任务，主键ID';
comment on column XXL_JOB_LOGGLUE.glue_type
    is 'GLUE类型';
comment on column XXL_JOB_LOGGLUE.glue_source
    is 'GLUE源代码';
comment on column XXL_JOB_LOGGLUE.glue_remark
    is 'GLUE备注';
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_LOGGLUE
    add primary key (ID)
    using index;
---------------------------------------
-- Create table
create table XXL_JOB_LOG_REPORT
(
    id            NUMBER(11) not null,
    trigger_day   DATE,
    running_count NUMBER(11) default 0 not null,
    suc_count     NUMBER(11) default 0 not null,
    fail_count    NUMBER(11) default 0 not null
);
-- Add comments to the columns
comment on column XXL_JOB_LOG_REPORT.trigger_day
    is '调度-时间';
comment on column XXL_JOB_LOG_REPORT.running_count
    is '运行中-日志数量';
comment on column XXL_JOB_LOG_REPORT.suc_count
    is '执行成功-日志数量';
comment on column XXL_JOB_LOG_REPORT.fail_count
    is '执行失败-日志数量';
-- Create/Recreate indexes
create unique index I_TRIGGER_DAY on XXL_JOB_LOG_REPORT (TRIGGER_DAY);
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_LOG_REPORT
    add primary key (ID)
    using index;
---------------------------------------
-- Create table
create table XXL_JOB_REGISTRY
(
    id             NUMBER(11) not null,
    registry_group NVARCHAR2(50) not null,
    registry_key   NVARCHAR2(255) not null,
    registry_value NVARCHAR2(255) not null,
    update_time    DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_REGISTRY
    add primary key (ID)
    using index;
alter table XXL_JOB_REGISTRY
    add constraint I_G_K_V unique (REGISTRY_GROUP, REGISTRY_KEY, REGISTRY_VALUE)
    using index;
--------------------------------------------
-- Create table
create table XXL_JOB_USER
(
    id         NUMBER(11) not null,
    username   NVARCHAR2(50) not null,
    password   NVARCHAR2(50) not null,
    role       NUMBER(4) not null,
    permission NVARCHAR2(255)
);
-- Add comments to the columns
comment on column XXL_JOB_USER.username
    is '账号';
comment on column XXL_JOB_USER.password
    is '密码';
comment on column XXL_JOB_USER.role
    is '角色：0-普通用户、1-管理员';
comment on column XXL_JOB_USER.permission
    is '权限：执行器ID列表，多个逗号分割';
-- Create/Recreate indexes
create unique index I_USERNAME on XXL_JOB_USER (USERNAME);
-- Create/Recreate primary, unique and foreign key constraints
alter table XXL_JOB_USER
    add primary key (ID)
    using index;
------------------------------------------------ 序列
create sequence XXL_JOB_GROUP_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_INFO_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_LOCK_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_LOGGLUE_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_LOG_REPORT_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_LOG_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;


create sequence XXL_JOB_REGISTRY_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

create sequence XXL_JOB_USER_SEQ
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



------------------------------------------------ 触发器
create or replace trigger xxl_job_group_tri
    before insert on  xxl_job_group for each row
begin
select to_char(xxl_job_group_seq.nextval) into :new.id from dual;
end xxl_job_group_tri;
/

create or replace trigger xxl_job_info_tri
    before insert on  xxl_job_info for each row
begin
select to_char(xxl_job_info_seq.nextval) into :new.id from dual;
end xxl_job_info_tri;
/

create or replace trigger xxl_job_logglue_tri
    before insert on  xxl_job_logglue for each row
begin
select to_char(xxl_job_logglue_seq.nextval) into :new.id from dual;
end xxl_job_logglue_tri;
/

create or replace trigger xxl_job_log_report_tri
    before insert on  xxl_job_log_report for each row
begin
select to_char(xxl_job_log_report_seq.nextval) into :new.id from dual;
end xxl_job_log_report_tri;
/

create or replace trigger xxl_job_log_tri
    before insert on  xxl_job_log for each row
begin
select to_char(xxl_job_log_seq.nextval) into :new.id from dual;
end xxl_job_log_tri;
/

create or replace trigger xxl_job_registry_tri
    before insert on  xxl_job_registry for each row
begin
select to_char(xxl_job_registry_seq.nextval) into :new.id from dual;
end xxl_job_registry_tri;
/

create or replace trigger xxl_job_user_tri
    before insert on  xxl_job_user for each row
begin
select to_char(xxl_job_user_seq.nextval) into :new.id from dual;
end xxl_job_user_tri;
/

INSERT INTO xxl_job_user (username, password, role, permission) VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO xxl_job_lock (lock_name) VALUES ('schedule_lock');