import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { Erro404Component } from './erro404.component';



const routes: Routes = [{ path: '', component: Erro404Component }];

@NgModule({
  declarations: [
    Erro404Component,
  ],
  imports: [
    CommonModule,
    RouterModule.forChild(routes)
  ]
})
export class Erro404Module { }
