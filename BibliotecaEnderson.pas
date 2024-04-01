program BibliotecaProyecto;

uses
  SysUtils; // Necesario para FileExists


type
  Alumno = record
    Nombre: string[50];
    Cedula: string[15];
  end;

  Libro = record
    ID: string[10];
    Titulo: string[100];
    Categoria: string[50];
    Existencias: integer;
  end;

  Prestamo = record
    IDLibro: string[10];
    CedulaAlumno: string[15];
    DiaPrestamo: integer;
    HoraPrestamo: integer;
    MinutosPrestamo: integer;
  end;

var
  ArchivoAlumnos, ArchivoLibros, ArchivoPrestamos: text;
  NuevoAlumno: Alumno;
  NuevoLibro: Libro;
  NuevoPrestamo: Prestamo;
  Nombre, Cedula: string;

function ExisteCedula(cedula: string): boolean;
var
  ArchivoAlumnos: text;
  Linea: string;
begin
  Assign(ArchivoAlumnos, 'alumnos.txt');
  Reset(ArchivoAlumnos);
  while not EOF(ArchivoAlumnos) do
  begin
    Readln(ArchivoAlumnos, Linea);
    if Pos('Cedula: ' + cedula, Linea) > 0 then
    begin
      Close(ArchivoAlumnos);
      ExisteCedula := True;
      Exit;
    end;
  end;
  Close(ArchivoAlumnos);
  ExisteCedula := False;
end;

function ExisteIDLibro(id: string): boolean;
var
  ArchivoLibros: text;
  Linea: string;
begin
  Assign(ArchivoLibros, 'libros.txt');
  Reset(ArchivoLibros);
  while not EOF(ArchivoLibros) do
  begin
    Readln(ArchivoLibros, Linea);
    if Linea = id then
    begin
      Close(ArchivoLibros);
      ExisteIDLibro := True;
      Exit;
    end;
  end;
  Close(ArchivoLibros);
  ExisteIDLibro := False;
end;

function PrestamoActivo(cedula, idLibro: string): boolean;
var
  ArchivoPrestamos: text;
  Linea: string;
  Datos: array[1..2] of string;
begin
  Assign(ArchivoPrestamos, 'prestamos.txt');
  Reset(ArchivoPrestamos);
  while not EOF(ArchivoPrestamos) do
  begin
    // Leer la cedula del alumno y el ID del libro de cada prestamo
    Readln(ArchivoPrestamos, Linea);
    Datos[1] := Copy(Linea, Pos(': ', Linea) + 2, Length(Linea));
    Readln(ArchivoPrestamos, Linea);
    Datos[2] := Copy(Linea, Pos(': ', Linea) + 2, Length(Linea));
    // Verificar si coincide con los datos proporcionados
    if (Datos[1] = cedula) and (Datos[2] = idLibro) then
    begin
      Close(ArchivoPrestamos);
      PrestamoActivo := True;
      Exit;
    end;
  end;
  Close(ArchivoPrestamos);
  PrestamoActivo := False;
end;

procedure AgregarAlumno(nombre, cedula: string);
var
  ArchivoAlumnos: text;
begin
  

  // Resto del procedimiento para agregar el alumno
  // Verificar si el archivo existe
  if not FileExists('alumnos.txt') then
  begin
    // Si el archivo no existe, crearlo
    Assign(ArchivoAlumnos, 'alumnos.txt');
    Rewrite(ArchivoAlumnos);
    Close(ArchivoAlumnos);
  end;
  
  if ExisteCedula(cedula) then
  begin
    writeln('La cedula ingresada ya existe. No se puede registrar otro alumno con la misma cedula.');
    Exit;
  end;

  // Abrir el archivo para añadir datos al final
  Assign(ArchivoAlumnos, 'alumnos.txt');
  Append(ArchivoAlumnos);  // Abre el archivo para añadir datos al final
  // Escribir el nombre y la cedula del alumno con el formato deseado
  writeln(ArchivoAlumnos, 'Nombre: ', nombre, ' - Cedula: ', cedula);
  Close(ArchivoAlumnos);
end;

procedure AgregarLibro(id, titulo, categoria: string; existencias: integer);
var
  ArchivoLibros: text;
begin
  

  // Resto del procedimiento para agregar el libro
  // Verificar si el archivo existe
  if not FileExists('libros.txt') then
  begin
    // Si el archivo no existe, crearlo
    Assign(ArchivoLibros, 'libros.txt');
    Rewrite(ArchivoLibros);
    Close(ArchivoLibros);
  end;

if ExisteIDLibro(id) then
  begin
    writeln('El ID del libro ingresado ya existe. Por favor, ingrese un ID único.');
    Exit;
  end;
  
  // Abrir el archivo para añadir datos al final
  Assign(ArchivoLibros, 'libros.txt');
  Append(ArchivoLibros);
  // Escribir los datos del libro en lineas separadas en el archivo
  writeln(ArchivoLibros, id);
  writeln(ArchivoLibros, titulo);
  writeln(ArchivoLibros, categoria);
  writeln(ArchivoLibros, existencias);
  Close(ArchivoLibros);
end;

procedure RegistrarPrestamo(cedula, idLibro: string; diaPrestamo, horaPrestamo, minutosPrestamo: integer);
var
  DatosLibro: array[1..4] of string;
  ArchivoLibros: text;
  ArchivoTemporal: text;
  LineaTemporal: string;
  Encontrado: boolean;
begin

	if not FileExists('prestamos.txt') then
  begin
    // Si el archivo no existe, crearlo
    Assign(ArchivoPrestamos, 'prestamos.txt');
    Rewrite(ArchivoPrestamos);
    Close(ArchivoPrestamos);
  end;


  // Verificar si la cedula del alumno existe
  if not ExisteCedula(cedula) then
  begin
    writeln('La cedula del alumno ingresada no existe.');
    Exit;
  end;

  // Verificar si el ID del libro existe
  if not ExisteIDLibro(idLibro) then
  begin
    writeln('El ID del libro ingresado no existe.');
    Exit;
  end;

  // Verificar si la hora y los minutos están dentro del horario de la biblioteca
  if (horaPrestamo < 8) or (horaPrestamo > 16) or
     ((horaPrestamo = 8) and (minutosPrestamo < 30)) or
     ((horaPrestamo = 16) and (minutosPrestamo > 30)) then
  begin
    writeln('Los prestamos solo pueden realizarse entre las 8:30 am y las 4:30 pm.');
    Exit;
  end;

  // Verificar si el dia del prestamo es un dia laborable (de lunes a viernes)
  if (diaPrestamo < 1) or (diaPrestamo > 5) then
  begin
    writeln('La biblioteca no trabaja los fines de semana. Los prestamos solo pueden hacerse de lunes a viernes.');
    Exit;
  end;

  // Actualizar el número de existencias del libro
  Assign(ArchivoLibros, 'libros.txt');
  Assign(ArchivoTemporal, 'temporal.txt');
  reset(ArchivoLibros);
  rewrite(ArchivoTemporal);
  Encontrado := False;
  while not eof(ArchivoLibros) do
  begin
    readln(ArchivoLibros, LineaTemporal);
    if LineaTemporal = idLibro then
    begin
      Encontrado := True;
      readln(ArchivoLibros, DatosLibro[1]); // Leer titulo
      readln(ArchivoLibros, DatosLibro[2]); // Leer categoria
      readln(ArchivoLibros, DatosLibro[3]); // Leer existencias
      DatosLibro[4] := IntToStr(StrToInt(DatosLibro[3]) - 1); // Restar una unidad al número de existencias
      writeln(ArchivoTemporal, idLibro);
      writeln(ArchivoTemporal, DatosLibro[1]);
      writeln(ArchivoTemporal, DatosLibro[2]);
      writeln(ArchivoTemporal, DatosLibro[4]);
    end
    else
    begin
      writeln(ArchivoTemporal, LineaTemporal);
      readln(ArchivoLibros, LineaTemporal); // Saltar lineas correspondientes al libro
      readln(ArchivoLibros, LineaTemporal);
      readln(ArchivoLibros, LineaTemporal);
    end;
  end;
  close(ArchivoLibros);
  close(ArchivoTemporal);
  erase(ArchivoLibros);
  rename(ArchivoTemporal, 'libros.txt');

  if not Encontrado then
  begin
    writeln('Error: No se encontró el libro con el ID especificado.');
    Exit;
  end;

  // Si la cedula y el ID del libro existen, y está dentro del horario y dia laborable, se puede proceder con el prestamo
  // Verificar si el archivo existe
  
  // Abrir el archivo para añadir datos al final
  Assign(ArchivoPrestamos, 'prestamos.txt');
  Append(ArchivoPrestamos);
  // Escribir los datos del prestamo en el archivo
  writeln(ArchivoPrestamos, 'Cedula: ', cedula);
  writeln(ArchivoPrestamos, 'ID Libro: ', idLibro);
  writeln(ArchivoPrestamos, 'Dia del Prestamo: ', diaPrestamo);
  writeln(ArchivoPrestamos, 'Hora del Prestamo: ', horaPrestamo, ':', minutosPrestamo);
  Close(ArchivoPrestamos);
  writeln('Prestamo registrado con exito.');
end;

procedure DevolverLibro(cedula, idLibro: string);
var
  DatosLibro: array[1..4] of string;
  ArchivoLibros, ArchivoPrestamos, ArchivoTemporal: text;
  Linea, LineaTemporal: string;
  Encontrado: boolean;
begin
  // Verificar si existe un prestamo activo para el libro y el alumno especificados
  if not PrestamoActivo(cedula, idLibro) then
  begin
    writeln('No hay un prestamo activo para el libro especificado y el alumno.');
    Exit;
  end;

  // Actualizar el número de existencias del libro
  Assign(ArchivoLibros, 'libros.txt');
  Assign(ArchivoTemporal, 'temporal.txt');
  reset(ArchivoLibros);
  rewrite(ArchivoTemporal);
  Encontrado := False;
  while not eof(ArchivoLibros) do
  begin
    readln(ArchivoLibros, Linea);
    if Linea = idLibro then
    begin
      Encontrado := True;
      readln(ArchivoLibros, DatosLibro[1]); // Leer titulo
      readln(ArchivoLibros, DatosLibro[2]); // Leer categoria
      readln(ArchivoLibros, DatosLibro[3]); // Leer existencias
      DatosLibro[4] := IntToStr(StrToInt(DatosLibro[3]) + 1); // Sumar una unidad al número de existencias
      writeln(ArchivoTemporal, idLibro);
      writeln(ArchivoTemporal, DatosLibro[1]);
      writeln(ArchivoTemporal, DatosLibro[2]);
      writeln(ArchivoTemporal, DatosLibro[4]);
    end
    else
    begin
      writeln(ArchivoTemporal, Linea);
      // Saltar lineas correspondientes al libro
      readln(ArchivoLibros, LineaTemporal);
      readln(ArchivoLibros, LineaTemporal);
      readln(ArchivoLibros, LineaTemporal);
    end;
  end;
  close(ArchivoLibros);
  close(ArchivoTemporal);
  erase(ArchivoLibros);
  rename(ArchivoTemporal, 'libros.txt');

  if not Encontrado then
  begin
    writeln('Error: No se encontró el libro con el ID especificado.');
    Exit;
  end;

  // Eliminar el registro del prestamo del archivo de prestamos
  Assign(ArchivoPrestamos, 'prestamos.txt');
  Assign(ArchivoTemporal, 'temporal.txt');
  reset(ArchivoPrestamos);
  rewrite(ArchivoTemporal);
  while not eof(ArchivoPrestamos) do
  begin
    readln(ArchivoPrestamos, Linea);
    if (Copy(Linea, 1, 8) <> 'Cedula: ') or (Copy(Linea, 10, Length(cedula)) <> cedula) then
      writeln(ArchivoTemporal, Linea)
    else
    begin
      // Saltar las lineas correspondientes al prestamo
      readln(ArchivoPrestamos, Linea);
      readln(ArchivoPrestamos, Linea);
      readln(ArchivoPrestamos, Linea);
      readln(ArchivoPrestamos, Linea);
    end;
  end;
  close(ArchivoPrestamos);
  close(ArchivoTemporal);
  erase(ArchivoPrestamos);
  rename(ArchivoTemporal, 'prestamos.txt');

  writeln('Libro devuelto con exito.');
end;

procedure MostrarPrestamosActivos;
var
  ArchivoPrestamos: text;
  Linea: string;
begin
  Assign(ArchivoPrestamos, 'prestamos.txt');
  Reset(ArchivoPrestamos); // Abre el archivo para lectura
  while not EOF(ArchivoPrestamos) do
  begin
    // Leer la linea completa del archivo
    readln(ArchivoPrestamos, Linea);
    // Mostrar la linea tal como está en el archivo
    writeln(Linea);
  end;
  Close(ArchivoPrestamos);
end;

procedure MostrarAlumnosDesdeArchivo;
var
  ArchivoAlumnos: text;
  Linea: string;
begin
  Assign(ArchivoAlumnos, 'alumnos.txt');
  Reset(ArchivoAlumnos); // Abre el archivo para lectura
  while not EOF(ArchivoAlumnos) do
  begin
    // Leer la línea completa del archivo
    readln(ArchivoAlumnos, Linea);
    // Mostrar la linea tal como está en el archivo
    writeln(Linea);
  end;
  Close(ArchivoAlumnos);
end;

procedure MostrarLibrosDesdeArchivo;
var
  ArchivoLibros: text;
  ID, Titulo, Categoria: string;
  Existencias: integer;
begin
  Assign(ArchivoLibros, 'libros.txt');
  Reset(ArchivoLibros); // Abre el archivo para lectura
  while not EOF(ArchivoLibros) do
  begin
    // Leer los datos del libro por separado
    readln(ArchivoLibros, ID);
    readln(ArchivoLibros, Titulo);
    readln(ArchivoLibros, Categoria);
    readln(ArchivoLibros, Existencias);
    
    // Mostrar los datos del libro con el formato deseado
    writeln('ID: ', ID);
    writeln('Titulo: ', Titulo);
    writeln('Categoria: ', Categoria);
    writeln('Existencias: ', Existencias);
    
    // Salto de linea para separar los libros
    writeln;
  end;
  Close(ArchivoLibros);
end;

procedure MostrarMenu;
begin
  writeln('*** Menu Principal ***');
  writeln('1. Agregar alumno');
  writeln('2. Agregar libro');
  writeln('3. Registrar prestamo');
  writeln('4. Devolver libro');
  writeln('5. Mostrar alumnos');
  writeln('6. Mostrar libros');
  writeln('7. Mostrar prestamos activos');
  writeln('8. Finalizar programa');
  writeln;
end;

procedure EjecutarMenu;
var
  Opcion: char;
  CedulaAlumno, IDLibro: string;
  DiaPrestamo, HoraPrestamo, MinutosPrestamo: integer;
begin
  repeat
    MostrarMenu;
    Write('Seleccione una opcion: ');
    Readln(Opcion);
    case Opcion of
      '1': begin
             Write('Ingrese el nombre del alumno: ');
             Readln(Nombre);
             Write('Ingrese la cedula del alumno: ');
             Readln(Cedula);
             AgregarAlumno(Nombre, Cedula);
           end;
      '2': begin
             Write('Ingrese el ID del libro: ');
             Readln(NuevoLibro.ID);
             Write('Ingrese el titulo del libro: ');
             Readln(NuevoLibro.Titulo);
             Write('Ingrese la categoria del libro: ');
             Readln(NuevoLibro.Categoria);
             Write('Ingrese las existencias del libro: ');
             Readln(NuevoLibro.Existencias);
             AgregarLibro(NuevoLibro.ID, NuevoLibro.Titulo, NuevoLibro.Categoria, NuevoLibro.Existencias);
           end;
      '3': begin
             Write('Ingrese la cedula del alumno: ');
             Readln(CedulaAlumno);
             // Verificar si la cedula del alumno existe
             if FileExists('alumnos.txt') then
             begin
               // Si existe, solicitar el ID del libro
               Write('Ingrese el ID del libro: ');
               Readln(IDLibro);
               // Verificar si el ID del libro existe
               if FileExists('libros.txt') then
               begin
                 // Si existe, solicitar el dia del prestamo
                 
                   Write('Ingrese el dia de la semana del prestamo (1-5): ');
                   Readln(DiaPrestamo);
                    
                
                 // Solicitar la hora del prestamo
               
                   Write('Ingrese la hora del prestamo (formato 24 horas): ');
                   Readln(HoraPrestamo);
                 
                 // Solicitar los minutos del prestamo
                 repeat
                   Write('Ingrese los minutos del prestamo (0-59): ');
                   Readln(MinutosPrestamo);
                 until (MinutosPrestamo >= 0) and (MinutosPrestamo <= 59);
                 // Registrar el prestamo
                 RegistrarPrestamo(CedulaAlumno, IDLibro, DiaPrestamo, HoraPrestamo, MinutosPrestamo);
                 
               end
               else
                 writeln('El ID del libro ingresado no existe.');
             end
             else
               writeln('La cedula del alumno ingresada no existe.');
           end;
      '4': begin
             Write('Ingrese la cedula del alumno: ');
             Readln(CedulaAlumno);
             Write('Ingrese el ID del libro: ');
             Readln(IDLibro);
             DevolverLibro(CedulaAlumno, IDLibro);
           end;
      '5': begin
             MostrarAlumnosDesdeArchivo;
           end;
      '6': begin
             MostrarLibrosDesdeArchivo;
           end;
      '7': begin
             MostrarPrestamosActivos;
           end;
      '8': begin
             writeln('Programa finalizado.');
           end;
    else
      writeln('Opcion no valida. Por favor, seleccione nuevamente.');
    end;
  until Opcion = '8';
end;

begin
  EjecutarMenu;
end.
