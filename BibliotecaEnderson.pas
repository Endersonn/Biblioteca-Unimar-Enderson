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

var
  NuevoAlumno: Alumno;
  NuevoLibro: Libro;
  Nombre, Cedula: string;




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
  // Abrir el archivo para añadir datos al final
  Assign(ArchivoAlumnos, 'alumnos.txt');
  Append(ArchivoAlumnos);  // Abre el archivo para añadir datos al final
  // Escribir el nombre y la cédula del alumno con el formato deseado
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
  // Abrir el archivo para añadir datos al final
  Assign(ArchivoLibros, 'libros.txt');
  Append(ArchivoLibros);
  // Escribir los datos del libro en líneas separadas en el archivo
  writeln(ArchivoLibros, id);
  writeln(ArchivoLibros, titulo);
  writeln(ArchivoLibros, categoria);
  writeln(ArchivoLibros, existencias);
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
             Write('Ingrese el título del libro: ');
             Readln(NuevoLibro.Titulo);
             Write('Ingrese la categoría del libro: ');
             Readln(NuevoLibro.Categoria);
             Write('Ingrese las existencias del libro: ');
             Readln(NuevoLibro.Existencias);
             AgregarLibro(NuevoLibro.ID, NuevoLibro.Titulo, NuevoLibro.Categoria, NuevoLibro.Existencias);
           end;
      '3': begin
          
           end;
      '4': begin
            
           end;
      '5': begin
           
           end;
      '6': begin
             
           end;
      '7': begin
             
           end;
      '8': begin
             writeln('Programa finalizado.');
           end;
    else
      writeln('Opción no valida. Por favor, seleccione nuevamente.');
    end;
  until Opcion = '8';
end;

begin
  EjecutarMenu;
end.
