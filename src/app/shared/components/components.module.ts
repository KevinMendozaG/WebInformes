import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { LayoutComponent } from './layout/layout.component';
import { HeaderComponent } from './header/header.component';
import { ToggleThemeComponent } from './toggle-theme/toggle-theme.component';

import { MatMenuModule } from '@angular/material/menu';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import {MatSidenavModule} from '@angular/material/sidenav';
import { HomeModule } from '../../pages/home/home.module';
import { HomeComponent } from '../../pages/home/home.component';
import { Erro404Component } from '../../pages/erro404/erro404.component';

const components = [
  LayoutComponent,
  HeaderComponent,
  ToggleThemeComponent
];

const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'error', component: Erro404Component }
];

@NgModule({
  declarations: [...components],
  imports: [
    CommonModule,
    MatMenuModule,
    MatIconModule,
    MatButtonModule,
    MatSidenavModule,
    HomeModule,
    RouterModule.forRoot(routes)
  ],
  exports: [...components]
})
export class ComponentsModule { }
