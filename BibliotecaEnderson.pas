program BibliotecaProyecto;

uses
  SysUtils; // Necesario para FileExists

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
            
           end;
      '2': begin
            
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
      writeln('Opcion no valida. Por favor, seleccione nuevamente.');
    end;
  until Opcion = '8';
end;

begin
  EjecutarMenu;
end.
