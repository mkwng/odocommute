
void loadEmployeePositions() {
  
  locationTable = new Table("assets/data/workersurvey.tsv");

  for (int i = 0; i < locationTable.getRowCount(); i++) {
    
    String name = locationTable.getString(i,0);
    float lon = locationTable.getFloat(i,3);
    float lat = locationTable.getFloat(i,2);
    int travelSecs = locationTable.getInt(i,1);
    
    employeePositions.add(new Position(name, lon, lat, travelSecs));
  }
}

