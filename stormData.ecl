import $;
IMPORT $.^.Visualizer;

Layout := RECORD
	UNSIGNED6 BeginYearMonth;
	UNSIGNED2 BeginDay;
	UNSIGNED4 BeginTime;
	UNSIGNED6 EndYearMonth;
	UNSIGNED2 EndDay;
	UNSIGNED4 EndTime;
	UNSIGNED EpisodeID;
	UNSIGNED EventID;
	STRING20 State;
	UNSIGNED4 StateFips;
	UNSIGNED4 Year;
	STRING20 MonthName;
	STRING EventType;
	STRING1 CZType;
	UNSIGNED4 CZFips;
	STRING CZName;
	STRING10 WFO;
	STRING BeginDateTime;
	STRING CZTimezone;
	STRING EndDateTime;
	UNSIGNED InjuriesDirect;
	UNSIGNED InjuriesIndirect;
	UNSIGNED DeathDirect;
	UNSIGNED DeathIndirect;
	STRING DamageProperty;
	STRING DamageCrops;
	STRING Source;
	UNSIGNED Magnitude;       //check size
	STRING2 MagnitudeType;
	STRING FloodCause;
	STRING Category;
	STRING3 TorFScale;
	REAL4 TorLength;
	UNSIGNED TorWidth;
	STRING TorOtherWFO;
	STRING TorOtherCZState;
	STRING TorOtherCZFips;
	STRING TorOtherCZName;
	REAL BeginRange;
	REAL BeginAzimuth;
	STRING BeginLoaction;
	REAL EndRange;
	REAL EndAzimuth;
	STRING EndLocation;
	REAL4 BeginLat;
	REAL4 BeginLon;
	REAL4 EndLat;
	REAL4 EndLon;
	STRING EpisodeNarrative;
	STRING EventNarrative;
	STRING LastModDate;
	STRING LastModTime;
	STRING LastCertDate;
	STRING LastCertTime;
	STRING LastMod;
	STRING LastCert;
	STRING AddcorrFlg;
	STRING AddcorrDate;
END;

DataFile := '~online::project::tornado::alldata__p454606156';
DataFile2 := '~online::project::storm::alldata__p280202545';
torFile := DATASET(DataFile, Layout, THOR);
stormFile := DATASET(DataFile2, Layout, THOR);
OUTPUT(COUNT(stormFile), NAMED('ALLStormsCount'));
//sortStormFile := SORT(stormFile, eventtype);
//dedupStorms := DEDUP(sortStormFile, eventtype);
//dedupStorms;
//OUTPUT(torFile, NAMED('ALLTornadoes'));
//OUTPUT(COUNT(torFile), NAMED('ALLTornadoesCount'));
//OUTPUT(stormFile, NAMED('ALLStorms'));
//OUTPUT(COUNT(stormFile), NAMED('ALLStormsCount'));

locationNotEmptyFile := torFile(beginloaction <> '');
//OUTPUT(count(locationEmptyFile), NAMED('HaveLocation'));

PropertyDamage := IF(torFile.DamageProperty[LENGTH(torFile.DamageProperty)]='K',
											((REAL)torFile.DamageProperty[1..(LENGTH(torFile.DamageProperty))])*1000,
											((REAL)torFile.DamageProperty[1..(LENGTH(torFile.DamageProperty))])*1000000
											);
StormPropertyDamage := IF(stormFile.DamageProperty[LENGTH(stormFile.DamageProperty)]='K',
											((REAL)stormFile.DamageProperty[1..(LENGTH(stormFile.DamageProperty))])*1000,
											((REAL)stormFile.DamageProperty[1..(LENGTH(stormFile.DamageProperty))])*1000000
											);					
Hour := IF(ROUND(torFile.begintime/100)=0,
									24,
									ROUND(torFile.begintime/100)
									);		
States := ['ALABAMA','ALASKA','ARIZONA','ARKANSAS','CALIFORNIA','COLORADO',
						'CONNECTICUT','DELAWARE','FLORIDA','GEORGIA','HAWAII','IDAHO',
						'ILLINOIS','INDIANA','IOWA','KANSAS','KENTUCKY','LOUISIANA','MAINE',
						'MARYLAND','MASSACGUSETTS','MICHIGAN','MINNESOTA','MISSISSIPPI','MISSOURI',
						'MONTANA','NEBRASKA','NEVADA','NEW HAMPSHIRE','NEW JERSEY','NEW MEXICO',
						'NEW YORK','NORTH CAROLINA','NORTH DAKOTA','OHIO','OKLAHOMA','OREGON',
						'PENNSYLVANIA','RHODE ISLAND','SOUTH CAROLINA','SOUTH DAKOTA','TENNESSEE',
						'TEXAS','UTAH','VERMONT','VIRGINIA','WASHINGTON','WEST VIRGINIA','WISCONSIN',
						'WYOMING','DISTRICT OF COLUMBIA','AMERICAN SAMOA','GUAM','NORTHEN MARIANA ISLANDS',
						'PUERTO RICO','VIRGIN ISLANDS'];
												
/*Visualization 1
table1 := TABLE(locationNotEmptyFile, {beginloaction, state, NumberOfTornadoes := COUNT(GROUP)}, beginloaction, state);
OUTPUT(SORT(table1, -NumberOfTornadoes), NAMED('Tornadoes_In_City'));
mappings :=  DATASET([  {'', 'beginloaction'}, 
                        {'Tornadoes', 'NumberOfTornadoes'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_In_City_Chart',, 'Tornadoes_In_City', mappings,,);
*/

/*Visualization 2
table2 := TABLE(torFile, {state, NumberOfTornadoes := COUNT(GROUP)}, state);
OUTPUT(SORT(table2, -NumberOfTornadoes), NAMED('Tornadoes_In_State'));
mappings2 :=  DATASET([  {'', 'state'}, 
                        {'Tornadoes', 'NumberOfTornadoes'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_In_State_Chart',, 'Tornadoes_In_State', mappings2,,);
*/

/*Visualization 3
table3 := TABLE(torFile, {Hour, NumberOfTornadoes := COUNT(GROUP)}, Hour);
OUTPUT(SORT(table3, Hour), NAMED('Tornadoes_Per_Hour'));
mappings3 :=  DATASET([  {'', 'Hour'},
                        {'Tornadoes', 'NumberOfTornadoes'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_Per_Hour_Chart',, 'Tornadoes_Per_Hour', mappings3,,);
*/

/*Visualization 4	 
table4 := TABLE(torFile, {Hour, TotalPropertyDamage:= SUM(GROUP, PropertyDamage)}, Hour);
OUTPUT(SORT(table4, Hour), NAMED('PropertyDamage_Per_Hour'));
mappings4 :=  DATASET([  {'', 'Hour'}, 
                        {'Damage', 'TotalPropertyDamage'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('PropertyDamage_Per_Hour_Chart',, 'PropertyDamage_Per_Hour', mappings4,,);
*/	

/*Visualization 5	
table5 := TABLE(torFile, {state, TotalPropertyDamage:= SUM(GROUP, PropertyDamage)}, state);
OUTPUT(SORT(table5, -TotalPropertyDamage), NAMED('PropertyDamage_Per_State'));
mappings5 :=  DATASET([  {'', 'state'}, 
                        {'Damage', 'TotalPropertyDamage'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('PropertyDamage_Per_State_Chart',, 'PropertyDamage_Per_State', mappings5,,);
*/

/*Visualization 6	
table6 := TABLE(locationNotEmptyFile, {beginloaction, state, TotalPropertyDamage:= SUM(GROUP, PropertyDamage)}, beginloaction, state);
OUTPUT(SORT(table6, -TotalPropertyDamage), NAMED('PropertyDamage_Per_City'));
mappings6 :=  DATASET([  {'', 'beginloaction'}, 
                        {'Damage', 'TotalPropertyDamage'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('PropertyDamage_Per_City_Chart',, 'PropertyDamage_Per_City', mappings6,,); 
*/

////////////    Albany, GA     //////////////////////////////////////////


/*Visualization 8
table8 := TABLE(locationNotEmptyFile, {beginloaction, state, TotalPropertyDamage:= SUM(GROUP, PropertyDamage)}, beginloaction, state);
OUTPUT(SORT(table8(beginloaction = 'ALBANY' AND state = 'GEORGIA'), -TotalPropertyDamage), NAMED('Tornadoes_In_AlbanyGA'));
mappings8 :=  DATASET([  {'', 'beginloaction'}, 
                        {'Damage', 'TotalPropertyDamage'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_In_AlbanyGA_Chart',, 'Tornadoes_In_AlbanyGA', mappings8,,);
*/


////////////////////////////////////////////////   FOR ALL STORMS   //////////////////////////////////////////////////////////////////////////////////////////////////////////

/*Visualization 7	
table7 := TABLE(stormFile, {state, TotalPropertyDamage:= SUM(GROUP, StormPropertyDamage)}, state);
OUTPUT(SORT(table7(state IN States), -TotalPropertyDamage), NAMED('STORM_PropertyDamage_Per_State'));
mappings7 :=  DATASET([  {'', 'state'}, 
                        {'Damage', 'TotalPropertyDamage'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('STORM_PropertyDamage_Per_State_Chart',, 'STORM_PropertyDamage_Per_State', mappings7,,);
*/

/*Visualization 9
table9 := TABLE(stormFile, {state, NumberOfStorms := COUNT(GROUP)}, state);
OUTPUT(SORT(table9(state IN States), -NumberOfStorms), NAMED('STORM_In_State'));
mappings9 :=  DATASET([  {'', 'state'}, 
                        {'Storms', 'NumberOfStorms'}], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('STORM_In_State_Chart',, 'STORM_In_State', mappings9,,);
*/

