import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  TextoCertificados = `Programa desarrollado en .NET C# con el cual se logra comprobar el 100% de los datos de todos los fondos, agilizando y optimizando el proceso de revisión y validación. También ayuda en una parte del proceso de generar certificados del fondo FICI. Antes, se recurría a armar los planos manualmente, lo que generaba riesgo al manipular estos datos, ya que es un proceso que tiene varios pasos y demora en promedio una semana. Con la solución implementada, se reduce a 20 minutos la generación de los planos, disminuyendo el riesgo en la manipulación de la información y optimizando el tiempo de ejecución.`;
  TextoAportes = `Los aportes por identificar de Fiduciaria Bancolombia se cargaban a las 4 p.m, ya que se dependía del reporte que hace conciliaciones. Esto conllevaba a una demora en la gestión, ya que los comerciales estarían montando los soportes de las partidas al día siguiente. Con el mejoramiento realizado, quitamos a conciliaciones de intermediario y nosotros mismos realizamos la conciliación y tenemos el resultado a las 9 a.m. Se envían correos a los comerciales y estos irán adjuntando los soportes el mismo día, pasando de una gestión en t+2 a t+1. La idea es hacer lo mismo para los aportes por identificar de otros bancos. Actualmente, se está explorando las llaves de cruces que se usarán, si se modifica de nuevo la EUC que hace el cruce o si optamos por un nuevo desarrollo en un lenguaje más potente.`;
  constructor() { }

  ngOnInit(): void {
  }

}
