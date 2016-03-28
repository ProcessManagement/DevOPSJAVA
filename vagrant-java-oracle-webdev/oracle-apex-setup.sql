#From https://community.oracle.com/message/2706653#2706653 this will allow apex to be accessed
DECLARE
l_configxml XMLTYPE;
l_value VARCHAR2(5) := 'true'; -- (true/false)
BEGIN
l_configxml := DBMS_XDB.cfg_get();

IF l_configxml.existsNode('/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access') = 0 THEN
-- Add missing element.
SELECT insertChildXML
(
l_configxml,
     '/xdbconfig/sysconfig/protocolconfig/httpconfig',
     'allow-repository-anonymous-access',
     XMLType('<allow-repository-anonymous-access xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">' ||
     l_value ||
     '</allow-repository-anonymous-access>'),
     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
     )
INTO l_configxml
FROM dual;

DBMS_OUTPUT.put_line('Element inserted.');
ELSE
-- Update existing element.
SELECT updateXML
(
DBMS_XDB.cfg_get(),
'/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access/text()',
l_value,
'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
)
INTO l_configxml
FROM dual;